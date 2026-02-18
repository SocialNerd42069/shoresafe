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

                    // Crew action
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
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.ssNavy.opacity(0.6))
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
        VStack(alignment: .leading, spacing: SSSpacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text("NEXT SHORE DAY")
                        .font(.ssOverline)
                        .foregroundStyle(Color.ssTextMuted)
                        .tracking(1.5)
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
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
        .shadow(color: SSShadow.card, radius: 12, x: 0, y: 4)
    }

    // MARK: - Active Timer Banner

    private func activeTimerBanner(_ timer: PortTimer) -> some View {
        NavigationLink {
            ActiveTimerView(timerVM: timerVM)
        } label: {
            HStack(spacing: SSSpacing.md) {
                // Pulsing dot
                Circle()
                    .fill(Color.ssCoral)
                    .frame(width: 10, height: 10)
                    .overlay {
                        Circle()
                            .stroke(Color.ssCoral.opacity(0.4), lineWidth: 2)
                            .frame(width: 18, height: 18)
                    }

                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text("ACTIVE")
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.6))
                        .tracking(1.5)
                    Text(timer.portName)
                        .font(.ssSubheadline)
                        .foregroundStyle(.white)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: SSSpacing.xs) {
                    Text("BE BACK BY")
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.5))
                        .tracking(1)
                    Text(timer.beBackBy.formatted(date: .omitted, time: .shortened))
                        .font(.ssCountdownSmall)
                        .foregroundStyle(.white)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(SSSpacing.cardPadding)
            .background(LinearGradient.ssOceanGradient)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
        }
    }

    // MARK: - Recent Timers

    private var recentTimersSection: some View {
        VStack(alignment: .leading, spacing: SSSpacing.md) {
            Text("RECENT")
                .font(.ssOverline)
                .foregroundStyle(Color.ssTextMuted)
                .tracking(1.5)

            ForEach(timerVM.recentTimers.filter { !$0.isActive }) { timer in
                HStack(spacing: SSSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(Color.ssSea.opacity(0.1))
                            .frame(width: 40, height: 40)
                        Image(systemName: timer.mode.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.ssSea)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(timer.portName)
                            .font(.ssBodyMedium)
                            .foregroundStyle(Color.ssTextPrimary)
                        Text("\(timer.mode.rawValue) \u{00B7} \(timer.bufferMinutes)m buffer")
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
                .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                .shadow(color: SSShadow.card, radius: 6, x: 0, y: 2)
            }
        }
    }

    // MARK: - Ship Time Card

    private var shipTimeCard: some View {
        HStack(spacing: SSSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.ssWarning.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.ssWarning)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Ship Time Reminder")
                    .font(.ssBodyMedium)
                    .foregroundStyle(Color.ssTextPrimary)
                Text("All-aboard is always in ship time. Your phone auto-adjusts to local.")
                    .font(.ssBodySmall)
                    .foregroundStyle(Color.ssTextSecondary)
            }
        }
        .padding(SSSpacing.cardPadding)
        .background(Color.ssWarning.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.xl)
                .stroke(Color.ssWarning.opacity(0.15), lineWidth: 1)
        }
    }
}
