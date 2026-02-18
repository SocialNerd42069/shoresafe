import SwiftUI

struct OnboardingDateView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 2, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.ssSunrise)

                Text("When do you sail?")
                    .ssOnboardingTitle()

                Text("We'll count down to all-aboard for every port day on your cruise.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
            }

            Spacer()

            DatePicker(
                "Cruise date",
                selection: $viewModel.data.cruiseDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color.ssCoral)
            .colorScheme(.dark)
            .padding(.horizontal, SSSpacing.sm)

            Spacer()

            HStack(spacing: SSSpacing.md) {
                SSButton(title: "Back", style: .ghost) {
                    viewModel.back()
                }
                .frame(width: 100)

                SSButton(title: "Next", icon: "arrow.right") {
                    viewModel.next()
                }
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}
