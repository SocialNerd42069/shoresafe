import SwiftUI

@main
struct ShoreSafeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var timerVM = TimerViewModel()
    @StateObject private var tripStore = TripStore()

    private var screenshotTarget: String? {
        ProcessInfo.processInfo.environment["SS_SCREENSHOT"]
    }

    var body: some Scene {
        WindowGroup {
#if DEBUG
            if let target = screenshotTarget {
                ScreenshotRouterView(target: target)
                    .environmentObject(tripStore)
            } else {
                mainAppFlow
                    .environmentObject(tripStore)
            }
#else
            mainAppFlow
                .environmentObject(tripStore)
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

    @StateObject private var setupVM = TripSetupViewModel()
    @StateObject private var timerVM = TimerViewModel()
    @EnvironmentObject var tripStore: TripStore

    private var themeID: SSThemeID? {
        guard let raw = ProcessInfo.processInfo.environment["SS_THEME"] else { return nil }
        let key = raw.lowercased()
        // Support both old names and new vibe names
        switch key {
        case "sunset":   return .sunset
        case "utility":  return .utility
        case "nautical": return .nautical
        case "poster":   return .poster
        case "beach":    return .beach
        case "disney":   return .disney
        default:         return SSThemeID(rawValue: key)
        }
    }

    init(target: String) {
        self.target = target
        // Pre-populate setup VM with sample data for screenshots
        let vm = TripSetupViewModel()
        vm.tripName = "Western Caribbean"
        vm.cruiseLine = "Royal Caribbean"
        vm.ports = [
            Port(name: "Cozumel", date: Calendar.current.date(byAdding: .day, value: 1, to: .now), allAboardTime: Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: .now), mode: .dock),
            Port(name: "Grand Cayman", date: Calendar.current.date(byAdding: .day, value: 2, to: .now), mode: .tender),
            Port(name: "Roatan", date: Calendar.current.date(byAdding: .day, value: 3, to: .now), mode: .dock),
        ]
        _setupVM = StateObject(wrappedValue: vm)
    }

    var body: some View {
        screenshotView
            .onAppear {
                // Set up trip store with sample data for home screen
                if tripStore.currentTrip == nil {
                    let trip = Trip(
                        name: "Western Caribbean",
                        cruiseLine: "Royal Caribbean",
                        sailDate: .now,
                        returnDate: Calendar.current.date(byAdding: .day, value: 7, to: .now),
                        shipTimeConfig: .local,
                        ports: [
                            Port(name: "Cozumel", date: Calendar.current.date(byAdding: .day, value: 0, to: .now), allAboardTime: Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: .now), mode: .dock),
                            Port(name: "Grand Cayman", date: Calendar.current.date(byAdding: .day, value: 1, to: .now), mode: .tender),
                            Port(name: "Roatan", date: Calendar.current.date(byAdding: .day, value: 2, to: .now), mode: .dock),
                        ],
                        bufferPersona: .balanced,
                        warningIntervals: [60, 30, 15, 5],
                        notificationsGranted: true
                    )
                    tripStore.save(trip)
                }

                // Pre-populate active timer for screenshots
                if timerVM.activeTimer == nil {
                    let calendar = Calendar.current
                    let allAboard = calendar.date(bySettingHour: 17, minute: 30, second: 0, of: .now) ?? .now
                    timerVM.activeTimer = PortTimer(
                        portName: "Cozumel",
                        allAboardTime: allAboard,
                        mode: .dock,
                        bufferMinutes: 60,
                        lastTenderBack: nil,
                        isActive: true
                    )
                    timerVM.startCountdown()
                }
            }
    }

    @ViewBuilder
    private var screenshotView: some View {
        // Themed routes — when SS_THEME is set, use themed screen variants
        if let theme = themeID {
            switch target.lowercased() {
            case "hook":
                ThemedHookView(viewModel: setupVM)
                    .ssTheme(theme)
            case "active":
                ThemedActiveTimerView(timerVM: timerVM)
                    .ssTheme(theme)
            default:
                fallbackView(for: target, themed: theme)
            }
        } else {
            // Original (non-themed) routes
            switch target.lowercased() {
            case "hook":
                OnboardingHookView(viewModel: setupVM)
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
            case "tripinfo":
                OnboardingTripInfoView(viewModel: setupVM)
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
            case "shiptime":
                OnboardingShipTimeView(viewModel: setupVM)
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
            case "ports":
                OnboardingPortsView(viewModel: setupVM)
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
            case "buffer":
                OnboardingBufferView(viewModel: setupVM)
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
            case "notifications":
                OnboardingNotificationsView(viewModel: setupVM)
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
            case "summary":
                OnboardingSummaryView(viewModel: setupVM, onComplete: {})
                    .background(LinearGradient.ssOnboardingBG)
                    .preferredColorScheme(.dark)
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

    @ViewBuilder
    private func fallbackView(for target: String, themed: SSThemeID) -> some View {
        VStack(spacing: 12) {
            Text("Theme '\(themed.rawValue)' not supported for '\(target)'")
                .font(.headline)
            Text("Themed screenshots: hook, active")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
#endif
