import SwiftUI

@main
struct ShoreSafeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var timerVM = TimerViewModel()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView(timerVM: timerVM)
            } else {
                OnboardingContainerView(isOnboardingComplete: $hasCompletedOnboarding)
            }
        }
    }
}
