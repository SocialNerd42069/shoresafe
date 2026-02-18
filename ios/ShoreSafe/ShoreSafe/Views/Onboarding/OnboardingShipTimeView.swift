import SwiftUI

struct OnboardingShipTimeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showLocalTime = false

    var body: some View {
        SSOnboardingPage(step: 1, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssWarning.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "clock.badge.exclamationmark")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssWarning)
                }

                Text("Ship time \u{2260}\nlocal time")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Your phone auto-adjusts to local time.\nThe ship doesn't. That mismatch strands\ncruisers every week.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.xl)

            // Interactive clock demo
            SSGlassCard(padding: SSSpacing.lg) {
                VStack(spacing: SSSpacing.md) {
                    Text("TAP TO SEE THE PROBLEM")
                        .font(.ssOverline)
                        .foregroundStyle(Color.ssTextMuted)
                        .tracking(1.5)

                    Button {
                        withAnimation(.spring(response: 0.5)) {
                            showLocalTime.toggle()
                        }
                    } label: {
                        HStack(spacing: 0) {
                            // Ship clock
                            VStack(spacing: SSSpacing.sm) {
                                Image(systemName: "ferry")
                                    .font(.system(size: 20, weight: .medium))
                                Text("Ship Time")
                                    .font(.ssCaption)
                                Text("4:30 PM")
                                    .font(.ssCountdownSmall)
                                    .foregroundStyle(Color.ssTextOnDark)
                            }
                            .foregroundStyle(Color.ssSea)
                            .frame(maxWidth: .infinity)

                            // Divider
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 1, height: 60)

                            // Phone clock
                            VStack(spacing: SSSpacing.sm) {
                                Image(systemName: "iphone")
                                    .font(.system(size: 20, weight: .medium))
                                Text("Your Phone")
                                    .font(.ssCaption)
                                Text(showLocalTime ? "3:30 PM" : "4:30 PM")
                                    .font(.ssCountdownSmall)
                                    .foregroundStyle(showLocalTime ? Color.ssDanger : Color.ssTextOnDark)
                                    .contentTransition(.numericText())
                            }
                            .foregroundStyle(showLocalTime ? Color.ssDanger : Color.ssTextMuted)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.plain)

                    if showLocalTime {
                        Text("All-aboard is 4:30 **ship time** — your phone says 3:30. You think you have an hour. You don't.")
                            .font(.ssBodySmall)
                            .foregroundStyle(Color.ssSunrise)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }

            Spacer()

            SSOnboardingNav(
                backLabel: "Back",
                nextLabel: "I see the risk",
                nextIcon: "checkmark",
                onBack: { viewModel.back() },
                onNext: { viewModel.next() }
            )
        }
    }
}
