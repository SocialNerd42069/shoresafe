import SwiftUI
import Combine

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var activeTimer: PortTimer? = nil
    @Published var recentTimers: [PortTimer] = PortTimer.mockRecent
    @Published var purchaseTier: PurchaseTier = .none

    // Create timer form state
    @Published var portName = ""
    @Published var allAboardTime = Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: .now) ?? .now
    @Published var portMode: PortMode = .dock
    @Published var bufferMinutes = 60
    @Published var hasLastTender = false
    @Published var lastTenderTime = Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: .now) ?? .now

    // Countdown
    @Published var remainingSeconds: TimeInterval = 0
    private var countdownTimer: AnyCancellable?

    var bufferOptions: [Int] {
        portMode == .dock ? [30, 45, 60, 90] : [60, 90, 120]
    }

    func createTimer() {
        let timer = PortTimer(
            portName: portName.isEmpty ? "Port Day" : portName,
            allAboardTime: allAboardTime,
            mode: portMode,
            bufferMinutes: bufferMinutes,
            lastTenderBack: (portMode == .tender && hasLastTender) ? lastTenderTime : nil,
            isActive: true
        )
        activeTimer = timer
        startCountdown()
    }

    func endTimer() {
        countdownTimer?.cancel()
        if let timer = activeTimer {
            var ended = timer
            ended.isActive = false
            recentTimers.insert(ended, at: 0)
        }
        activeTimer = nil
    }

    func startCountdown() {
        updateRemaining()
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateRemaining()
            }
    }

    private func updateRemaining() {
        guard let timer = activeTimer else { return }
        remainingSeconds = max(0, timer.beBackBy.timeIntervalSinceNow)
    }

    var countdownHours: Int { Int(remainingSeconds) / 3600 }
    var countdownMinutes: Int { (Int(remainingSeconds) % 3600) / 60 }
    var countdownSecs: Int { Int(remainingSeconds) % 60 }

    var countdownFormatted: String {
        String(format: "%d:%02d:%02d", countdownHours, countdownMinutes, countdownSecs)
    }

    var isUrgent: Bool { remainingSeconds < 1800 && remainingSeconds > 0 }
    var isCritical: Bool { remainingSeconds < 900 && remainingSeconds > 0 }
}
