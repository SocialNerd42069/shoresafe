import SwiftUI

struct OnboardingHookView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 0, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.xl) {
                // Hero icon — ship + clock conveys the core concept
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.ssCoral.opacity(0.2), Color.ssCoral.opacity(0.05)],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)

                    Image(systemName: "ferry.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.ssCoral, .ssSunrise],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                }

                VStack(spacing: SSSpacing.md) {
                    Text("Never miss\nthe ship.")
                        .ssOnboardingTitle()
                        .multilineTextAlignment(.center)

                    Text("ShoreSafe tracks ship time so you always make it back before all-aboard — even when your phone clock lies.")
                        .ssOnboardingBody()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, SSSpacing.sm)
                }
            }

            Spacer()
            Spacer()

            SSButton(title: "Get started", icon: "arrow.right") {
                viewModel.next()
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}
