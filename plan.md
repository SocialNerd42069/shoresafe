# PierRunner (iOS) — Phased PDR / Plan

## 0) Product One-Liner
**PierRunner** is an offline-first port-day countdown + alarm that keeps you aligned to **ship time** (not local time) and handles **tender-port buffers** so you don’t become a pier runner.

## 1) Goal (V1)
Ship a beautiful **iOS-only** app (light-first UI, dark mode optional) that:
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
- **Modern-cruise onboarding that actually sets up the trip** (not just marketing screens)
- **Ship Time Guardrail** so the user can’t accidentally rely on phone local time
  - The app UI should always make the displayed time basis explicit: **SHIP TIME** badge near times and countdowns
  - Widgets/complications should also show that the countdown is based on **SHIP TIME**
- **Trip Setup**: add ports now, fill in “all aboard / last tender” times later when you get them
- **Itinerary input**: manual entry **or** paste-to-import (best-effort parsing; times can be missing)
- **Port Day plan** (per port): Dock vs Tender, buffers, escalating alarms
- **Escalating alarms** (90/60/30/15/5 + “Head back now”) using local notifications
  - Design the notifications (title/body) with cruise context + ship-time clarity
  - Consider actionable notifications (e.g., “I’m on my way”) where supported
- **On my way / Silence**: a big, obvious “I’m on my way” control that *de-escalates or disables* further alarms for the current port day
- **Big countdown screen** with one truth: “BE BACK BY __ (SHIP TIME)”
- **Invite-based Crew sharing** (paid tier): host can invite up to 3 guests onto the same pass (enforced server-side)

## 5) How It Works (Logistics)
### Setup (first run)
**Goal:** the user ends onboarding with a real “Trip” configured so Home is immediately useful.

1) **Ship time**
   - Default: **Ship time = local time**
   - If not: set ship-time behavior (simple offset or ship time zone vs phone)
   - Explain *why it matters* (“ship time” is the schedule the ship runs on).
2) **Ports**
   - Add ports manually **or** paste/import a basic itinerary list.
   - Each port can exist with **missing** fields.
3) **Defaults**
   - Default buffers (Dock vs Tender)
   - Default alert schedule

### Port configuration (can be done now or later)
For each port day, store:
- Name + date
- Mode: Dock vs Tender
- **All aboard time** (optional at first; can be unknown)
- **Last tender back** (optional; only if tender)
- Buffer override (optional)

Home should clearly prompt the user when critical times are missing.

### “On my way” / disable alarms (critical UX)
Once the user is actually heading back, they need one obvious action to stop the app from nagging them:
- Primary control on the Active Timer screen: **“I’m on my way”**
- Behavior (V1): **silence** remaining alerts for this port day timer (or switch to a single gentle “final check” alert)
- Must be offline and immediate (local notifications cancellation/update)

### Timer math (once times exist)
- **hardDeadline** =
  - tender w/ lastTenderTime: `min(allAboard, lastTender)`
  - otherwise: `allAboard`
- **beBackBy** = `hardDeadline - buffer`
- Schedule alerts at: `beBackBy - {90,60,30,15,5}` and at `beBackBy`.

### Offline
Once a port day timer is started, alarms are **local**. No connectivity required.

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

### Onboarding / Trip Setup (baseline)
Design vibe: premium modern-cruise; deep navy + sunrise coral accents; strong hierarchy; simple forms; progress dots; subtle motion.

**Outcome:** user finishes with a usable Trip (ports can be imported/added now; times can be missing and filled later).

1) **Hook / why this matters**
   - “Ship time isn’t your phone time.” (teach the risk fast)
2) **Ship time setup**
   - Ship time = local time (default)
   - Or: ship time differs → set offset / ship time zone
3) **Add ports**
   - Option A: Manual add (name + date)
   - Option B: Import (paste itinerary text) → parse best-effort
   - Copy makes clear: **all aboard / last tender times can be added later**
4) **Defaults**
   - Buffer defaults (Dock vs Tender)
   - Alert schedule preset
5) **Notifications**
   - Soft-ask → request permission (after the user has “committed”)
6) **Trip ready summary**
   - CTA: “Set up my first port day” / “View my next port day”

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
  - Includes: escalating schedule, notification content design, and the ability to cancel/de-escalate via “I’m on my way”
- IAP: StoreKit 2

### Potential V1.1+ surfaces (nice-to-have)
- **iPhone Widget:** show next port day + countdown to be-back-by (ship time)
- **Apple Watch companion:** at minimum, mirrored critical notifications; ideally a simple “I’m on my way” action from the watch

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
