import SwiftUI

struct HomeView: View {
    @ObservedObject var timerVM: TimerViewModel
    @State private var showCreateTimer = false
    @State private var showPaywall = false
    @State private var showSettings = false
    @State private var showCrewInvites = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SSSpacing.lg) {
                    // Header card
                    headerCard

                    // Active timer banner
                    if let active = timerVM.activeTimer {
                        activeTimerBanner(active)
                    }

                    // Main CTA
                    if timerVM.activeTimer == nil {
                        SSButton(title: "Start Port Timer", icon: "timer") {
                            if timerVM.purchaseTier == .none {
                                showPaywall = true
                            } else {
                                showCreateTimer = true
                            }
                        }
                    }

                    // Quick actions
                    if timerVM.purchaseTier == .crew {
                        SSButton(title: "Manage Crew", style: .outline, icon: "person.3") {
                            showCrewInvites = true
                        }
                    }

                    // Recent timers
                    if !timerVM.recentTimers.isEmpty {
                        recentTimersSection
                    }

                    // Ship time reminder
                    shipTimeCard
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.vertical, SSSpacing.screenVertical)
            }
            .background(Color.ssSurface)
            .navigationTitle("ShoreSafe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.ssNavy)
                    }
                }
            }
            .sheet(isPresented: $showCreateTimer) {
                CreateTimerView(timerVM: timerVM)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(
                    currentTier: $timerVM.purchaseTier,
                    onPurchase: { tier in
                        timerVM.purchaseTier = tier
                        showPaywall = false
                        showCreateTimer = true
                    }
                )
            }
            .sheet(isPresented: $showCrewInvites) {
                CrewInvitesView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    // MARK: - Header Card

    private var headerCard: some View {
        VStack(spacing: SSSpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text("Next Shore Day")
                        .font(.ssCaption)
                        .foregroundStyle(Color.ssTextMuted)
                        .textCase(.uppercase)
                    Text("Cozumel, Mexico")
                        .font(.ssHeadline)
                        .foregroundStyle(Color.ssTextPrimary)
                }
                Spacer()
                SSBadge(text: "Tomorrow", color: .ssSea)
            }
        }
        .padding(SSSpacing.cardPadding)
        .background(Color.ssCard)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
        .shadow(color: SSShadow.card, radius: 8, x: 0, y: 2)
    }

    // MARK: - Active Timer Banner

    private func activeTimerBanner(_ timer: PortTimer) -> some View {
        NavigationLink {
            ActiveTimerView(timerVM: timerVM)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text("ACTIVE TIMER")
                        .font(.ssCaption)
                        .foregroundStyle(.white.opacity(0.7))
                        .tracking(1)
                    Text(timer.portName)
                        .font(.ssSubheadline)
                        .foregroundStyle(.white)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: SSSpacing.xs) {
                    Text("BE BACK BY")
                        .font(.ssCaptionSmall)
                        .foregroundStyle(.white.opacity(0.6))
                    Text(timer.beBackBy.formatted(date: .omitted, time: .shortened))
                        .font(.ssCountdownSmall)
                        .foregroundStyle(.white)
                }

                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(SSSpacing.cardPadding)
            .background(LinearGradient.ssNavyGradient)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
        }
    }

    // MARK: - Recent Timers

    private var recentTimersSection: some View {
        VStack(alignment: .leading, spacing: SSSpacing.md) {
            Text("Recent")
                .font(.ssSubheadline)
                .foregroundStyle(Color.ssTextSecondary)

            ForEach(timerVM.recentTimers.filter { !$0.isActive }) { timer in
                HStack(spacing: SSSpacing.md) {
                    Image(systemName: timer.mode.icon)
                        .font(.body)
                        .foregroundStyle(Color.ssSea)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(timer.portName)
                            .font(.ssBodyMedium)
                            .foregroundStyle(Color.ssTextPrimary)
                        Text("\(timer.mode.rawValue) · \(timer.bufferMinutes)m buffer")
                            .font(.ssBodySmall)
                            .foregroundStyle(Color.ssTextSecondary)
                    }

                    Spacer()

                    Text(timer.allAboardTime.formatted(date: .omitted, time: .shortened))
                        .font(.ssBodySmall)
                        .foregroundStyle(Color.ssTextMuted)
                }
                .padding(SSSpacing.md)
                .background(Color.ssCard)
                .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
            }
        }
    }

    // MARK: - Ship Time Card

    private var shipTimeCard: some View {
        HStack(spacing: SSSpacing.md) {
            Image(systemName: "clock.badge.exclamationmark")
                .font(.title2)
                .foregroundStyle(Color.ssWarning)

            VStack(alignment: .leading, spacing: 2) {
                Text("Ship Time Reminder")
                    .font(.ssBodyMedium)
                    .foregroundStyle(Color.ssTextPrimary)
                Text("Your phone auto-adjusts to local time. All-aboard is always in ship time.")
                    .font(.ssBodySmall)
                    .foregroundStyle(Color.ssTextSecondary)
            }
        }
        .padding(SSSpacing.cardPadding)
        .background(Color.ssWarning.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.lg)
                .stroke(Color.ssWarning.opacity(0.2), lineWidth: 1)
        }
    }
}
