import SwiftUI

@main
struct ShoreSafeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var timerVM = TimerViewModel()

    private var screenshotTarget: String? {
        ProcessInfo.processInfo.environment["SS_SCREENSHOT"]
    }

    var body: some Scene {
        WindowGroup {
#if DEBUG
            if let target = screenshotTarget {
                ScreenshotRouterView(target: target)
            } else {
                mainAppFlow
            }
#else
            mainAppFlow
#endif
        }
    }

    @ViewBuilder
    private var mainAppFlow: some View {
        if hasCompletedOnboarding {
            HomeView(timerVM: timerVM)
        } else {
            OnboardingContainerView(isOnboardingComplete: $hasCompletedOnboarding)
        }
    }
}

#if DEBUG
private struct ScreenshotRouterView: View {
    let target: String

    @StateObject private var onboardingVM = OnboardingViewModel()
    @StateObject private var timerVM = TimerViewModel()

    var body: some View {
        screenshotView
    }

    @ViewBuilder
    private var screenshotView: some View {
        switch target.lowercased() {
        case "hook":
            OnboardingHookView(viewModel: onboardingVM)
        case "date":
            OnboardingDateView(viewModel: onboardingVM)
        case "line":
            OnboardingCruiseLineView(viewModel: onboardingVM)
        case "shiptime":
            OnboardingShipTimeView(viewModel: onboardingVM)
        case "buffer":
            OnboardingBufferView(viewModel: onboardingVM)
        case "warnings":
            OnboardingWarningsView(viewModel: onboardingVM)
        case "notifications":
            OnboardingNotificationsView(viewModel: onboardingVM)
        case "summary":
            OnboardingSummaryView(viewModel: onboardingVM, onComplete: {})
        case "paywall":
            PaywallView(currentTier: .constant(.solo), onPurchase: { _ in })
        case "home":
            HomeView(timerVM: timerVM)
        case "create":
            CreateTimerView(timerVM: timerVM)
        case "active":
            ActiveTimerView(timerVM: timerVM)
        case "crew":
            CrewInvitesView()
        default:
            VStack(spacing: 12) {
                Text("Unknown SS_SCREENSHOT target")
                    .font(.headline)
                Text(target)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}
#endif
