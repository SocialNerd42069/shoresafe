# ShoreSafe Backend (FastAPI)

## What this is
A small API that:
- creates a 7-day pass after purchase
- lets guests join by invite code
- answers whether a device is entitled

No accounts. The invite code is the secret.

## Pass rules
- `solo_pass_7d`: guestLimit = 0
- `crew_pass_7d`: guestLimit = 3

## API
Base URL example: `https://api-shoresafe.<VPS>.sslip.io`

### POST /passes
Create a pass after purchase.

Request body:
```json
{
  "type": "crew_pass_7d",
  "hostDeviceId": "DEVICE-UUID",
  "purchaseInfo": {
    "storekitTransactionId": "..."
  }
}
```

Response:
```json
{
  "passId": "...",
  "shareCode": "...",
  "type": "crew_pass_7d",
  "expiresAt": "2025-01-01T12:00:00Z",
  "guestLimit": 3
}
```

### POST /passes/join
Join a guest by share code (idempotent per `guestDeviceId`).

Request body:
```json
{
  "shareCode": "...",
  "guestDeviceId": "DEVICE-UUID"
}
```

Response:
```json
{
  "passId": "...",
  "shareCode": "...",
  "type": "crew_pass_7d",
  "expiresAt": "2025-01-01T12:00:00Z",
  "guestsJoined": 2,
  "guestLimit": 3
}
```

Possible errors:
- 403 if the pass does not allow guests
- 409 if the guest limit is reached
- 410 if the pass is expired

### GET /entitlements
Check entitlement state for a device.

Query params:
- `deviceId` (required)
- `shareCode` or `passId` (one required)

Response:
```json
{
  "isActive": true,
  "type": "crew_pass_7d",
  "expiresAt": "2025-01-01T12:00:00Z",
  "guestsJoined": 2,
  "guestLimit": 3
}
```

If the device has not joined (and is not the host), the API returns 403.

## iOS integration notes (non-UI)
Use a stable `deviceId` stored on the device (ex: UUID saved in Keychain).

1) Host creates pass after purchase
- Call `POST /passes` with `type` and `hostDeviceId`.
- Save `passId`, `shareCode`, and `expiresAt` locally.

2) Host generates invite link
- Use the `shareCode` from `POST /passes`.
- Example link: `https://shoresafe.app/invite?code=SHARE_CODE`.
- Share that link or a QR that contains it.

3) Guest joins pass
- App reads the `code` from the link/QR.
- Call `POST /passes/join` with `shareCode` and `guestDeviceId`.
- Save the returned `passId` locally.
- Call `GET /entitlements` on launch or resume to confirm the pass is active. Use `passId` if you have it, otherwise `shareCode` works too.

## Local dev
Python 3.10+ recommended.
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app:app --host 0.0.0.0 --port 8000
```

## Deployment (systemd)
1) Copy the backend to your VPS, for example:
```
/opt/shoresafe/backend
```
2) Create a venv and install requirements.
3) Create `/etc/shoresafe-backend.env` with:
```
SHORESAFE_DB_PATH=/opt/shoresafe/backend/data/shoresafe.db
```
4) Copy `backend/deploy/shoresafe-backend.service` to:
```
/etc/systemd/system/shoresafe-backend.service
```
5) Edit the service file paths and the `User`/`Group` if needed.
6) Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable shoresafe-backend
sudo systemctl start shoresafe-backend
sudo systemctl status shoresafe-backend
```

## Caddy reverse proxy (safe snippet)
**Important: append/merge this into your existing Caddyfile. Do NOT overwrite it.**

Snippet (also in `backend/deploy/caddy-snippet.txt`):
```
api-shoresafe.<VPS>.sslip.io {
    reverse_proxy 127.0.0.1:8000
}
```

After editing Caddy:
```bash
sudo caddy reload --config /etc/caddy/Caddyfile
```
