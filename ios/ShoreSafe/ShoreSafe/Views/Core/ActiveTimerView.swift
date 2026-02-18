import SwiftUI

struct ActiveTimerView: View {
    @ObservedObject var timerVM: TimerViewModel
    @State private var showEndConfirmation = false

    var body: some View {
        ZStack {
            // Background shifts based on urgency
            backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Ship time badge
                HStack {
                    SSBadge(text: "SHIP TIME", color: .ssSea)
                    Spacer()
                    if let timer = timerVM.activeTimer {
                        SSBadge(
                            text: timer.mode.rawValue.uppercased(),
                            color: timer.mode == .tender ? .ssWarning : .ssNavyLight
                        )
                    }
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.top, SSSpacing.md)

                Spacer()

                // Main countdown
                VStack(spacing: SSSpacing.sm) {
                    Text("BE BACK BY")
                        .font(.ssCaption)
                        .foregroundStyle(.white.opacity(0.6))
                        .tracking(2)

                    if let timer = timerVM.activeTimer {
                        Text(timer.beBackBy.formatted(date: .omitted, time: .shortened))
                            .font(.ssDisplayLarge)
                            .foregroundStyle(.white)
                    }

                    // Countdown
                    Text(timerVM.countdownFormatted)
                        .font(.ssCountdownLarge)
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.3), value: timerVM.remainingSeconds)

                    Text("remaining")
                        .font(.ssBodySmall)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                // Timer details
                if let timer = timerVM.activeTimer {
                    timerDetails(timer)
                }

                Spacer()

                // Alert schedule
                alertScheduleSection

                // Bottom actions
                VStack(spacing: SSSpacing.md) {
                    SSButton(title: "Edit Buffer", style: .outline, icon: "slider.horizontal.3") {
                        // Placeholder
                    }

                    SSButton(title: "End Timer", style: .ghost, icon: "xmark") {
                        showEndConfirmation = true
                    }
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.bottom, SSSpacing.xxl)
            }
        }
        .preferredColorScheme(.dark)
        .alert("End Timer?", isPresented: $showEndConfirmation) {
            Button("End Timer", role: .destructive) {
                timerVM.endTimer()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your port-day alerts will be cancelled.")
        }
        .onAppear {
            timerVM.startCountdown()
        }
    }

    // MARK: - Background

    @ViewBuilder
    private var backgroundGradient: some View {
        if timerVM.isCritical {
            LinearGradient(
                colors: [Color.ssDanger, Color.ssDanger.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else if timerVM.isUrgent {
            LinearGradient(
                colors: [Color.ssWarning.opacity(0.9), Color.ssCoral],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            LinearGradient.ssNavyGradient
        }
    }

    // MARK: - Timer Details

    private func timerDetails(_ timer: PortTimer) -> some View {
        HStack(spacing: SSSpacing.xl) {
            VStack(spacing: SSSpacing.xs) {
                Text("ALL ABOARD")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(.white.opacity(0.5))
                Text(timer.allAboardTime.formatted(date: .omitted, time: .shortened))
                    .font(.ssSubheadline)
                    .foregroundStyle(.white)
            }

            if timer.mode == .tender, let lastTender = timer.lastTenderBack {
                VStack(spacing: SSSpacing.xs) {
                    Text("LAST TENDER")
                        .font(.ssCaptionSmall)
                        .foregroundStyle(.white.opacity(0.5))
                    Text(lastTender.formatted(date: .omitted, time: .shortened))
                        .font(.ssSubheadline)
                        .foregroundStyle(.white)
                }
            }

            VStack(spacing: SSSpacing.xs) {
                Text("BUFFER")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(.white.opacity(0.5))
                Text("\(timer.bufferMinutes) min")
                    .font(.ssSubheadline)
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: - Alert Schedule

    private var alertScheduleSection: some View {
        VStack(spacing: SSSpacing.sm) {
            Text("ALERT SCHEDULE")
                .font(.ssCaptionSmall)
                .foregroundStyle(.white.opacity(0.4))
                .tracking(1.5)

            if let timer = timerVM.activeTimer {
                HStack(spacing: SSSpacing.sm) {
                    ForEach(timer.alertSchedule.prefix(5)) { alert in
                        VStack(spacing: 2) {
                            Image(systemName: alert.minutesBefore == 0 ? "bell.and.waves.left.and.right" : "bell")
                                .font(.caption2)
                            Text(alert.minutesBefore == 0 ? "Now" : "\(alert.minutesBefore)m")
                                .font(.ssCaptionSmall)
                        }
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
        .padding(.vertical, SSSpacing.md)
    }
}
