import SwiftUI

struct OnboardingHookView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 0, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.lg) {
                // Icon cluster
                ZStack {
                    Circle()
                        .fill(Color.ssCoral.opacity(0.15))
                        .frame(width: 140, height: 140)

                    Image(systemName: "sun.and.horizon.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.ssCoral, .ssSunrise],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                }
                .padding(.bottom, SSSpacing.md)

                Text("Your ship.\nYour shore day.\nZero stress.")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("ShoreSafe keeps you aligned to ship time so you never become a pier runner.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SSSpacing.md)
            }

            Spacer()
            Spacer()

            SSButton(title: "Let's set up", icon: "arrow.right") {
                viewModel.next()
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}
