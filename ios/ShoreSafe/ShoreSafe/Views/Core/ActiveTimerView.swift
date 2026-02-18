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
                // Top badges
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
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.5))
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
                        .foregroundStyle(.white.opacity(0.4))
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
                    SSButton(title: "Edit Buffer", style: .glass, icon: "slider.horizontal.3") {
                        // Placeholder
                    }

                    Button {
                        showEndConfirmation = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .medium))
                            Text("End Timer")
                                .font(.ssBodyMedium)
                        }
                        .foregroundStyle(.white.opacity(0.4))
                    }
                    .buttonStyle(.plain)
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
            LinearGradient.ssCriticalGradient
        } else if timerVM.isUrgent {
            LinearGradient.ssUrgentGradient
        } else {
            LinearGradient.ssOceanGradient
        }
    }

    // MARK: - Timer Details

    private func timerDetails(_ timer: PortTimer) -> some View {
        HStack(spacing: 0) {
            VStack(spacing: SSSpacing.xs) {
                Text("ALL ABOARD")
                    .font(.ssOverline)
                    .foregroundStyle(.white.opacity(0.4))
                    .tracking(1)
                Text(timer.allAboardTime.formatted(date: .omitted, time: .shortened))
                    .font(.ssSubheadline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)

            if timer.mode == .tender, let lastTender = timer.lastTenderBack {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 36)

                VStack(spacing: SSSpacing.xs) {
                    Text("LAST TENDER")
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.4))
                        .tracking(1)
                    Text(lastTender.formatted(date: .omitted, time: .shortened))
                        .font(.ssSubheadline)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
            }

            RoundedRectangle(cornerRadius: 1)
                .fill(Color.white.opacity(0.1))
                .frame(width: 1, height: 36)

            VStack(spacing: SSSpacing.xs) {
                Text("BUFFER")
                    .font(.ssOverline)
                    .foregroundStyle(.white.opacity(0.4))
                    .tracking(1)
                Text("\(timer.bufferMinutes) min")
                    .font(.ssSubheadline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
    }

    // MARK: - Alert Schedule

    private var alertScheduleSection: some View {
        VStack(spacing: SSSpacing.sm) {
            Text("ALERT SCHEDULE")
                .font(.ssOverline)
                .foregroundStyle(.white.opacity(0.3))
                .tracking(1.5)

            if let timer = timerVM.activeTimer {
                HStack(spacing: SSSpacing.sm) {
                    ForEach(timer.alertSchedule.prefix(5)) { alert in
                        VStack(spacing: 4) {
                            Image(systemName: alert.minutesBefore == 0 ? "bell.and.waves.left.and.right" : "bell")
                                .font(.system(size: 12, weight: .medium))
                            Text(alert.minutesBefore == 0 ? "Now" : "\(alert.minutesBefore)m")
                                .font(.ssCaptionSmall)
                        }
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
        .padding(.vertical, SSSpacing.md)
    }
}
