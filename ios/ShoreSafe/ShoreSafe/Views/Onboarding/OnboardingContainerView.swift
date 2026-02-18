import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingComplete: Bool

    var body: some View {
        ZStack {
            LinearGradient.ssOnboardingBG
                .ignoresSafeArea()

            TabView(selection: $viewModel.currentStep) {
                OnboardingHookView(viewModel: viewModel)
                    .tag(0)
                OnboardingShipTimeView(viewModel: viewModel)
                    .tag(1)
                OnboardingDateView(viewModel: viewModel)
                    .tag(2)
                OnboardingCruiseLineView(viewModel: viewModel)
                    .tag(3)
                OnboardingBufferView(viewModel: viewModel)
                    .tag(4)
                OnboardingWarningsView(viewModel: viewModel)
                    .tag(5)
                OnboardingNotificationsView(viewModel: viewModel)
                    .tag(6)
                OnboardingSummaryView(viewModel: viewModel, onComplete: {
                    isOnboardingComplete = true
                })
                    .tag(7)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.45), value: viewModel.currentStep)
        }
        .preferredColorScheme(.dark)
    }
}
