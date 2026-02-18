import SwiftUI

struct OnboardingShipTimeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showLocalTime = false

    var body: some View {
        SSOnboardingPage(step: 1, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.ssWarning)

                Text("Ship time ≠\nlocal time")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Your phone auto-adjusts to local time zones. The ship doesn't. That mismatch strands cruisers every week.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SSSpacing.xs)
            }

            Spacer().frame(height: SSSpacing.xl)

            // Interactive demo
            VStack(spacing: SSSpacing.md) {
                Text("TAP THE CLOCKS")
                    .font(.ssCaption)
                    .foregroundStyle(Color.ssTextMuted)
                    .tracking(1.5)

                Button {
                    withAnimation(.spring(response: 0.5)) {
                        showLocalTime.toggle()
                    }
                } label: {
                    HStack(spacing: SSSpacing.xl) {
                        // Ship clock
                        VStack(spacing: SSSpacing.sm) {
                            Image(systemName: "ferry")
                                .font(.title2)
                            Text("Ship Time")
                                .font(.ssCaption)
                            Text("4:30 PM")
                                .font(.ssCountdownSmall)
                                .foregroundStyle(Color.ssTextOnDark)
                        }
                        .foregroundStyle(Color.ssSea)

                        Image(systemName: "arrow.left.arrow.right")
                            .font(.title3)
                            .foregroundStyle(Color.ssWarning)
                            .rotationEffect(.degrees(showLocalTime ? 180 : 0))

                        // Phone clock
                        VStack(spacing: SSSpacing.sm) {
                            Image(systemName: "iphone")
                                .font(.title2)
                            Text("Your Phone")
                                .font(.ssCaption)
                            Text(showLocalTime ? "3:30 PM" : "4:30 PM")
                                .font(.ssCountdownSmall)
                                .foregroundStyle(showLocalTime ? Color.ssDanger : Color.ssTextOnDark)
                                .contentTransition(.numericText())
                        }
                        .foregroundStyle(showLocalTime ? Color.ssDanger : Color.ssTextMuted)
                    }
                    .padding(SSSpacing.lg)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                    .overlay {
                        RoundedRectangle(cornerRadius: SSRadius.lg)
                            .stroke(
                                showLocalTime ? Color.ssDanger.opacity(0.5) : Color.white.opacity(0.15),
                                lineWidth: 1
                            )
                    }
                }
                .buttonStyle(.plain)

                if showLocalTime {
                    Text("All-aboard is 4:30 **ship time** — but your phone says 3:30. You think you have an hour. You don't.")
                        .font(.ssBodySmall)
                        .foregroundStyle(Color.ssSunrise)
                        .multilineTextAlignment(.center)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }

            Spacer()

            HStack(spacing: SSSpacing.md) {
                SSButton(title: "Back", style: .ghost) {
                    viewModel.back()
                }
                .frame(width: 100)

                SSButton(title: "I see the risk", icon: "checkmark") {
                    viewModel.next()
                }
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}
