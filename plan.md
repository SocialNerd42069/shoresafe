# ShoreSafe (iOS) — Phased PDR / Plan

## 0) Product One-Liner
**ShoreSafe** is an offline-first port-day countdown + alarm that keeps you aligned to **ship time** (not local time) and handles **tender-port buffers** so you don’t become a pier runner.

## 1) Goal (V1)
Ship a beautiful **iOS-only** app that:
- can be set up in **<30 seconds** while stepping off the gangway
- works **offline** reliably (no Wi‑Fi required)
- prevents the two real failure modes:
  1) **ship time vs local time** confusion
  2) **tender ports** ("last tender back" + crowd/boarding friction)

Success metric (early): strangers recommend it in cruise subreddits / FB groups as the default “set this before you leave the ship” tool.

## 2) Product Positioning (laser focus)
ShoreSafe is **not** a general cruise companion.

It is exactly:
- **Port-day alarms**
- **Ship-time clarity**
- **Tender-port buffers**

Nothing else ships in V1 unless it directly improves “don’t miss the ship.”

## 3) Non-Goals (V1)
- No cruise-line integrations
- No itinerary scraping
- No accounts/logins (no email)
- No chat / excursions / packing lists
- No guarantee language (we’re an alarm tool, not a safety promise)

## 4) Core Feature Bullets (what the app *does*)
- **Sexy modern onboarding** that collects trip context and teaches ship-time risk
- **Ship Time Guardrail** so the user doesn’t rely on their phone’s local time by accident
- **Port Timer** you set once per port day (Dock vs Tender)
- **Tender Mode** that pushes you earlier and optionally uses “Last Tender Back” if you have it
- **Buffer defaults** (Dock: 60m, Tender: 90m) with quick adjust
- **Escalating alarms** (90/60/30/15/5 + “Head back now”) using local notifications
- **Big countdown screen** with one truth: “BE BACK BY __ (SHIP TIME)”
- **Invite-based Crew sharing** (paid tier): host can invite up to 3 guests onto the same pass (enforced server-side)

## 5) How It Works (Logistics)
### Setup (30 seconds)
1) Choose **All Aboard time** (required)
2) Choose **Dock** or **Tender**
3) Pick buffer (default suggested)
4) (Tender) Optional: enter **Last Tender Back** time if you have it
5) Tap **Start Port Timer**

### Timer math
- **hardDeadline** =
  - tender w/ lastTenderTime: `min(allAboard, lastTender)`
  - otherwise: `allAboard`
- **beBackBy** = `hardDeadline - buffer`
- Schedule alerts at: `beBackBy - {90,60,30,15,5}` and at `beBackBy`.

### Offline
Once a timer is started, alarms are **local**. No connectivity required.

## 6) Pricing / Monetization (V1 — charge immediately)
Two one-time “per cruise” products (7-day window):

- **Solo Cruise Pass — $4.99**
  - 1 device (no sharing)
  - No timer sharing

- **Crew Pass — $10.99**
  - Host + **invite up to 3 guests** (4 total)
  - Invite works with friends (not Apple Family) via link/QR

**Paywall placement:** after onboarding + summary, when they tap **Plan my first port day** (or **Start Port Timer**).

**Note on wording:** avoid “Family Plan” language in UI. Use **Crew Pass** / **Group Pass** to prevent confusion with Apple Family Sharing.

(Implementation: StoreKit 2 + backend entitlement validation.)

## 7) UX / Screen Map (SwiftUI)

### Onboarding (use the “Perfect Day Ashore” flow as baseline)
Design vibe: full-bleed port imagery, deep navy + sunrise coral accents, progress dots, subtle micro-animations.

1) **Hook**
   - “Your ship. Your shore day. Zero stress.”
2) **Cruise date** (required)
3) **Cruise line + ship** (optional; logo chips + autocomplete)
4) **Ship time vs local time** (the “aha” lesson with a mini demo)
5) **Buffer persona** (Safety Net / Balanced / Thrill Seeker)
6) **Warning chips** (preselected based on persona)
7) **Notifications soft-ask** → request permission
8) **Summary/celebration** → CTA: “Plan my first port day”

### Core screens
- **Home**
  - Big CTA: “Start Port Timer”
  - Next sailing info
  - Recent timers
- **Create Port Timer**
  - All-aboard time picker (ship time)
  - Mode: Dock / Tender
  - Buffer chips
  - Tender: “Do you have Last Tender Back?” yes/no
- **Paywall**
  - Solo ($4.99) vs Crew ($10.99)
  - Bullet value props (offline, ship time clarity, tender mode, escalating alarms)
- **Active Timer (primary)**
  - “BE BACK BY” + countdown
  - Ship Time badge
  - Edit buffer / end timer
  - Alert schedule preview
- **Crew Invites (Crew Pass only)**
  - Show invite slots remaining (3)
  - Share link/QR
  - Manage guests (optional v1: show list; v1.1: remove guest)
- **Settings**
  - Default buffers
  - Alert schedule
  - Restore purchase
  - Help: ship time vs local time

## 8) Technical Architecture (iOS + Backend)
### iOS
- SwiftUI
- Local persistence: SwiftData (timers, defaults, onboarding answers)
- Notifications: UNUserNotificationCenter
- IAP: StoreKit 2

### Backend (required for Crew Pass enforcement)
Minimal “entitlements + invites” service.

**Responsibilities**
- Create pass record for purchase
- Generate share codes
- Allow join with max guest limit (Crew = 3 guests)
- Return signed entitlement token to app

**Endpoints (example)**
- `POST /passes` → creates a pass (solo/crew) + returns `passId`, `shareCode`
- `POST /passes/join` → joins guest to pass if slots remain
- `GET /entitlements` → returns current entitlement state

**No accounts:** use anonymous device identifiers + signed tokens.

## 9) Landing Page (required for launch)
Goal: convert SEO + social traffic into App Store installs.

One-page site with cruise-modern branding:
- Hero (A/B test): “Ship Time. Local Time. One Clear Alarm.”
- The problem: “Ship time is not your phone’s time.”
- What it does: dual clock + tender alerts + port-day alarms
- How it works: 3-step setup
- FAQ (includes “no guarantees”)
- Pricing: Solo $4.99 / Crew $10.99

## 10) Execution Plan (Agents)
### UI / Onboarding / Landing page design — Claude Code (Opus 4.6)
Deliverables:
- SwiftUI design system (colors/type/components)
- Onboarding screens (modern multi-step)
- Home/Create/Active Timer + Crew Invite UI
- Landing page design + copy structure to match app branding

### Build / Implementation — Codex (high)
Deliverables:
- iOS project scaffold
- Models + local persistence
- Notification scheduling engine
- Tender mode logic
- StoreKit 2 paywall + pass purchase
- Backend service + entitlement validation + invite joins

**Work split rule:** Opus touches UI/UX/SwiftUI views; Codex touches logic/models/notifications/StoreKit/backend.

## 11) Subagent Research References (use as inputs)
When building onboarding and landing page, reference these outputs:
- **Onboarding:** “Perfect Day Ashore” flow (date → ship → ship-time lesson → buffer personas → warning chips → soft notification ask → summary)
- **Landing page:** cruise-modern structure (hero + ship-time explainer + tender explainer + how-it-works + FAQ + SEO block)
- **Copy deck:** the rip-current/ocean-safety copy was wrong domain — **do not use**. Generate copy from cruise-specific language (pier runner, ship time confusion, last tender anxiety).

## 12) Repo / Folder
- Location: `~/Projects/shoresafe/`
- iOS project: `ShoreSafe.xcodeproj`

## 13) Open Questions (for Kaspar)
1) Domain name for landing page (e.g., `shoresafe.app`)?
2) Backend hosting preference (Cloudflare Worker vs VPS)?
3) V1 guest management: do we need “remove guest” or can we ship without it?
