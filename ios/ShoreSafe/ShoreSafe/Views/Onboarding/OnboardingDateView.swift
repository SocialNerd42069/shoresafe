import SwiftUI

struct OnboardingDateView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 2, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssSunrise.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssSunrise)
                }

                Text("When do you sail?")
                    .ssOnboardingTitle()

                Text("We'll set up port-day countdowns\nfor your cruise.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.md)

            DatePicker(
                "Cruise date",
                selection: $viewModel.data.cruiseDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color.ssCoral)
            .colorScheme(.dark)
            .padding(.horizontal, SSSpacing.xs)

            Spacer()

            SSOnboardingNav(
                backLabel: "Back",
                nextLabel: "Next",
                onBack: { viewModel.back() },
                onNext: { viewModel.next() }
            )
        }
    }
}
