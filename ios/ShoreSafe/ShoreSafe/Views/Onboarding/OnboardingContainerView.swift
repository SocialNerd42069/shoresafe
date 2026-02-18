import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = TripSetupViewModel()
    @Binding var isOnboardingComplete: Bool
    @EnvironmentObject var tripStore: TripStore

    var body: some View {
        ZStack {
            LinearGradient.ssOnboardingBG
                .ignoresSafeArea()

            TabView(selection: $viewModel.currentStep) {
                OnboardingHookView(viewModel: viewModel)
                    .tag(0)
                OnboardingTripInfoView(viewModel: viewModel)
                    .tag(1)
                OnboardingShipTimeView(viewModel: viewModel)
                    .tag(2)
                OnboardingPortsView(viewModel: viewModel)
                    .tag(3)
                OnboardingBufferView(viewModel: viewModel)
                    .tag(4)
                OnboardingNotificationsView(viewModel: viewModel)
                    .tag(5)
                OnboardingSummaryView(viewModel: viewModel, onComplete: {
                    let trip = viewModel.buildTrip()
                    tripStore.save(trip)
                    isOnboardingComplete = true
                })
                    .tag(6)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.45), value: viewModel.currentStep)
        }
        .preferredColorScheme(.dark)
    }
}
