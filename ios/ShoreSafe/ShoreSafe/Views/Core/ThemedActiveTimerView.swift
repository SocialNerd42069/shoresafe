import SwiftUI

/// Theme-aware variant of the active timer screen for screenshot generation.
struct ThemedActiveTimerView: View {
    @ObservedObject var timerVM: TimerViewModel
    @Environment(\.ssTheme) private var theme
    @State private var showEndConfirmation = false

    var body: some View {
        ZStack {
            backgroundForState
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top badges
                HStack {
                    themedBadge(text: "SHIP TIME", color: theme.badgeColor)
                    Spacer()
                    if let timer = timerVM.activeTimer {
                        themedBadge(
                            text: timer.mode.rawValue.uppercased(),
                            color: timer.mode == .tender ? theme.badgeUrgentColor : theme.badgeColor.opacity(0.7)
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
                        .foregroundStyle(theme.timerTextMuted)
                        .tracking(2)

                    if let timer = timerVM.activeTimer {
                        Text(timer.beBackBy.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 36, weight: .bold, design: theme.displayDesign))
                            .foregroundStyle(theme.timerTextPrimary)
                    }

                    // Countdown
                    Text(timerVM.countdownFormatted)
                        .font(.system(size: 60, weight: .heavy, design: theme.countdownDesign))
                        .foregroundStyle(theme.timerTextPrimary)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.3), value: timerVM.remainingSeconds)

                    Text("remaining")
                        .font(.ssBodySmall)
                        .foregroundStyle(theme.timerTextMuted)
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
                    Button {
                        // Placeholder
                    } label: {
                        HStack(spacing: SSSpacing.sm) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Edit Buffer")
                                .font(.ssSubheadline)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, SSSpacing.lg)
                        .foregroundStyle(theme.timerTextPrimary)
                        .background(theme.glassBackground)
                        .clipShape(RoundedRectangle(cornerRadius: theme.buttonRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: theme.buttonRadius)
                                .stroke(theme.glassBorder, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        showEndConfirmation = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .medium))
                            Text("End Timer")
                                .font(.ssBodyMedium)
                        }
                        .foregroundStyle(theme.timerTextMuted)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.bottom, SSSpacing.xxl)
            }
        }
        .preferredColorScheme(theme.colorScheme)
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

    private var activeBackground: AnyShapeStyle {
        if timerVM.isCritical {
            return theme.timerCriticalBackground
        } else if timerVM.isUrgent {
            return theme.timerUrgentBackground
        } else {
            return theme.timerBackground
        }
    }

    private var backgroundForState: some View {
        Rectangle().fill(activeBackground)
    }

    // MARK: - Badge

    private func themedBadge(text: String, color: Color) -> some View {
        Text(text)
            .font(.ssCaption)
            .foregroundStyle(theme.colorScheme == .dark ? .white : .white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(Capsule())
    }

    // MARK: - Timer Details

    private func timerDetails(_ timer: PortTimer) -> some View {
        HStack(spacing: 0) {
            VStack(spacing: SSSpacing.xs) {
                Text("ALL ABOARD")
                    .font(.ssOverline)
                    .foregroundStyle(theme.timerTextMuted)
                    .tracking(1)
                Text(timer.allAboardTime.formatted(date: .omitted, time: .shortened))
                    .font(.ssSubheadline)
                    .foregroundStyle(theme.timerTextPrimary)
            }
            .frame(maxWidth: .infinity)

            if timer.mode == .tender, let lastTender = timer.lastTenderBack {
                divider

                VStack(spacing: SSSpacing.xs) {
                    Text("LAST TENDER")
                        .font(.ssOverline)
                        .foregroundStyle(theme.timerTextMuted)
                        .tracking(1)
                    Text(lastTender.formatted(date: .omitted, time: .shortened))
                        .font(.ssSubheadline)
                        .foregroundStyle(theme.timerTextPrimary)
                }
                .frame(maxWidth: .infinity)
            }

            divider

            VStack(spacing: SSSpacing.xs) {
                Text("BUFFER")
                    .font(.ssOverline)
                    .foregroundStyle(theme.timerTextMuted)
                    .tracking(1)
                Text("\(timer.bufferMinutes) min")
                    .font(.ssSubheadline)
                    .foregroundStyle(theme.timerTextPrimary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
    }

    private var divider: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(theme.timerTextMuted.opacity(0.3))
            .frame(width: 1, height: 36)
    }

    // MARK: - Alert Schedule

    private var alertScheduleSection: some View {
        VStack(spacing: SSSpacing.sm) {
            Text("ALERT SCHEDULE")
                .font(.ssOverline)
                .foregroundStyle(theme.timerTextMuted.opacity(0.8))
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
                        .foregroundStyle(theme.timerTextSecondary)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
        .padding(.vertical, SSSpacing.md)
    }
}
