import json
import os
import secrets
import sqlite3
import threading
import uuid
from datetime import datetime, timedelta, timezone

from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel


PASS_CONFIG = {
    "solo_pass_7d": {"guestLimit": 0, "days": 7},
    "crew_pass_7d": {"guestLimit": 3, "days": 7},
}

DB_PATH = os.environ.get(
    "SHORESAFE_DB_PATH",
    os.path.join(os.path.dirname(__file__), "data", "shoresafe.db"),
)

DB_LOCK = threading.Lock()


class PassCreateRequest(BaseModel):
    type: str
    hostDeviceId: str
    purchaseInfo: dict | None = None


class PassCreateResponse(BaseModel):
    passId: str
    shareCode: str
    type: str
    expiresAt: str
    guestLimit: int


class PassJoinRequest(BaseModel):
    shareCode: str
    guestDeviceId: str


class PassJoinResponse(BaseModel):
    passId: str
    shareCode: str
    type: str
    expiresAt: str
    guestsJoined: int
    guestLimit: int


class EntitlementResponse(BaseModel):
    isActive: bool
    type: str
    expiresAt: str
    guestsJoined: int
    guestLimit: int


app = FastAPI(title="ShoreSafe Backend", version="0.1.0")


def _ensure_db_dir() -> None:
    dir_path = os.path.dirname(DB_PATH)
    if dir_path:
        os.makedirs(dir_path, exist_ok=True)


def _get_db() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH, timeout=30)
    conn.row_factory = sqlite3.Row
    return conn


def _isoformat_z(value: datetime) -> str:
    return value.astimezone(timezone.utc).replace(microsecond=0).isoformat().replace(
        "+00:00", "Z"
    )


def _parse_iso_z(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def _generate_share_code(conn: sqlite3.Connection) -> str:
    for _ in range(5):
        code = secrets.token_urlsafe(9).rstrip("=")
        existing = conn.execute(
            "SELECT 1 FROM passes WHERE share_code = ?", (code,)
        ).fetchone()
        if not existing:
            return code
    raise RuntimeError("Failed to create unique share code")


def _get_pass_by_share_code(conn: sqlite3.Connection, share_code: str):
    return conn.execute(
        "SELECT * FROM passes WHERE share_code = ?", (share_code,)
    ).fetchone()


def _get_pass_by_id(conn: sqlite3.Connection, pass_id: str):
    return conn.execute("SELECT * FROM passes WHERE id = ?", (pass_id,)).fetchone()


def _count_guests(conn: sqlite3.Connection, pass_id: str) -> int:
    row = conn.execute(
        "SELECT COUNT(*) AS count FROM guest_joins WHERE pass_id = ?", (pass_id,)
    ).fetchone()
    return int(row["count"]) if row else 0


def _guest_exists(conn: sqlite3.Connection, pass_id: str, guest_device_id: str) -> bool:
    row = conn.execute(
        "SELECT 1 FROM guest_joins WHERE pass_id = ? AND guest_device_id = ?",
        (pass_id, guest_device_id),
    ).fetchone()
    return row is not None


def _init_db() -> None:
    _ensure_db_dir()
    with _get_db() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS passes (
                id TEXT PRIMARY KEY,
                type TEXT NOT NULL,
                created_at TEXT NOT NULL,
                expires_at TEXT NOT NULL,
                host_device_id TEXT NOT NULL,
                share_code TEXT NOT NULL UNIQUE,
                purchase_info TEXT
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS guest_joins (
                id TEXT PRIMARY KEY,
                pass_id TEXT NOT NULL,
                guest_device_id TEXT NOT NULL,
                joined_at TEXT NOT NULL,
                UNIQUE(pass_id, guest_device_id),
                FOREIGN KEY(pass_id) REFERENCES passes(id)
            )
            """
        )
        conn.commit()


@app.get("/health")
def health_check():
    return {"ok": True}


@app.post("/passes", response_model=PassCreateResponse)
def create_pass(body: PassCreateRequest):
    if body.type not in PASS_CONFIG:
        raise HTTPException(status_code=400, detail="Invalid pass type")

    now = datetime.now(timezone.utc)
    expires_at = now + timedelta(days=PASS_CONFIG[body.type]["days"])

    with DB_LOCK:
        with _get_db() as conn:
            share_code = _generate_share_code(conn)
            pass_id = str(uuid.uuid4())
            conn.execute(
                """
                INSERT INTO passes (id, type, created_at, expires_at, host_device_id, share_code, purchase_info)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    pass_id,
                    body.type,
                    _isoformat_z(now),
                    _isoformat_z(expires_at),
                    body.hostDeviceId,
                    share_code,
                    json.dumps(body.purchaseInfo) if body.purchaseInfo else None,
                ),
            )
            conn.commit()

    return PassCreateResponse(
        passId=pass_id,
        shareCode=share_code,
        type=body.type,
        expiresAt=_isoformat_z(expires_at),
        guestLimit=PASS_CONFIG[body.type]["guestLimit"],
    )


@app.post("/passes/join", response_model=PassJoinResponse)
def join_pass(body: PassJoinRequest):
    with DB_LOCK:
        with _get_db() as conn:
            pass_row = _get_pass_by_share_code(conn, body.shareCode)
            if not pass_row:
                raise HTTPException(status_code=404, detail="Share code not found")

            pass_type = pass_row["type"]
            guest_limit = PASS_CONFIG[pass_type]["guestLimit"]

            expires_at = _parse_iso_z(pass_row["expires_at"])
            if datetime.now(timezone.utc) >= expires_at:
                raise HTTPException(status_code=410, detail="Pass expired")

            if guest_limit == 0:
                raise HTTPException(status_code=403, detail="Pass does not allow guests")

            if body.guestDeviceId == pass_row["host_device_id"]:
                guests_joined = _count_guests(conn, pass_row["id"])
                return PassJoinResponse(
                    passId=pass_row["id"],
                    shareCode=pass_row["share_code"],
                    type=pass_type,
                    expiresAt=pass_row["expires_at"],
                    guestsJoined=guests_joined,
                    guestLimit=guest_limit,
                )

            if _guest_exists(conn, pass_row["id"], body.guestDeviceId):
                guests_joined = _count_guests(conn, pass_row["id"])
                return PassJoinResponse(
                    passId=pass_row["id"],
                    shareCode=pass_row["share_code"],
                    type=pass_type,
                    expiresAt=pass_row["expires_at"],
                    guestsJoined=guests_joined,
                    guestLimit=guest_limit,
                )

            guests_joined = _count_guests(conn, pass_row["id"])
            if guests_joined >= guest_limit:
                raise HTTPException(status_code=409, detail="Guest limit reached")

            conn.execute(
                """
                INSERT INTO guest_joins (id, pass_id, guest_device_id, joined_at)
                VALUES (?, ?, ?, ?)
                """,
                (
                    str(uuid.uuid4()),
                    pass_row["id"],
                    body.guestDeviceId,
                    _isoformat_z(datetime.now(timezone.utc)),
                ),
            )
            conn.commit()

            guests_joined = _count_guests(conn, pass_row["id"])

            return PassJoinResponse(
                passId=pass_row["id"],
                shareCode=pass_row["share_code"],
                type=pass_type,
                expiresAt=pass_row["expires_at"],
                guestsJoined=guests_joined,
                guestLimit=guest_limit,
            )


@app.get("/entitlements", response_model=EntitlementResponse)
def get_entitlements(
    deviceId: str = Query(...),
    shareCode: str | None = Query(None),
    passId: str | None = Query(None),
):
    if not shareCode and not passId:
        raise HTTPException(status_code=400, detail="shareCode or passId is required")

    with _get_db() as conn:
        pass_row = None
        if passId:
            pass_row = _get_pass_by_id(conn, passId)
        elif shareCode:
            pass_row = _get_pass_by_share_code(conn, shareCode)

        if not pass_row:
            raise HTTPException(status_code=404, detail="Pass not found")

        is_host = deviceId == pass_row["host_device_id"]
        is_guest = _guest_exists(conn, pass_row["id"], deviceId)
        if not is_host and not is_guest:
            raise HTTPException(status_code=403, detail="Device not joined")

        pass_type = pass_row["type"]
        guest_limit = PASS_CONFIG[pass_type]["guestLimit"]
        guests_joined = _count_guests(conn, pass_row["id"])
        expires_at = _parse_iso_z(pass_row["expires_at"])
        is_active = datetime.now(timezone.utc) < expires_at

        return EntitlementResponse(
            isActive=is_active,
            type=pass_type,
            expiresAt=pass_row["expires_at"],
            guestsJoined=guests_joined,
            guestLimit=guest_limit,
        )


_init_db()
