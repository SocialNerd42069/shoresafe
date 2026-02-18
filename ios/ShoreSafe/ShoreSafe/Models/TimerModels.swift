import Foundation

// MARK: - Port Mode

enum PortMode: String, CaseIterable, Identifiable {
    case dock = "Dock"
    case tender = "Tender"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dock: "arrow.down.to.line"
        case .tender: "ferry"
        }
    }

    var description: String {
        switch self {
        case .dock: "Ship docks at the pier"
        case .tender: "Smaller boats shuttle to shore"
        }
    }

    var defaultBuffer: Int {
        switch self {
        case .dock: 60
        case .tender: 90
        }
    }
}

// MARK: - Port Timer

struct PortTimer: Identifiable {
    let id = UUID()
    var portName: String
    var allAboardTime: Date
    var mode: PortMode
    var bufferMinutes: Int
    var lastTenderBack: Date?
    var isActive: Bool

    var hardDeadline: Date {
        if mode == .tender, let lastTender = lastTenderBack {
            return min(allAboardTime, lastTender)
        }
        return allAboardTime
    }

    var beBackBy: Date {
        hardDeadline.addingTimeInterval(-Double(bufferMinutes) * 60)
    }

    var alertSchedule: [AlertTiming] {
        let intervals = [90, 60, 30, 15, 5, 0]
        return intervals.compactMap { minutes in
            let fireDate = beBackBy.addingTimeInterval(-Double(minutes) * 60)
            guard fireDate > .now else { return nil }
            return AlertTiming(minutesBefore: minutes, fireDate: fireDate)
        }
    }
}

struct AlertTiming: Identifiable {
    let id = UUID()
    let minutesBefore: Int
    let fireDate: Date

    var label: String {
        if minutesBefore == 0 {
            return "Head back now"
        }
        return "\(minutesBefore) min before"
    }
}

// MARK: - Purchase Tier

enum PurchaseTier: String {
    case none
    case solo
    case crew
}

// MARK: - Crew Member

struct CrewMember: Identifiable {
    let id = UUID()
    let name: String
    let joinedAt: Date
    var isHost: Bool = false
}

// MARK: - Mock Data

extension PortTimer {
    static let mockActive: PortTimer = {
        let calendar = Calendar.current
        let allAboard = calendar.date(bySettingHour: 17, minute: 30, second: 0, of: .now)!
        return PortTimer(
            portName: "Cozumel",
            allAboardTime: allAboard,
            mode: .dock,
            bufferMinutes: 60,
            lastTenderBack: nil,
            isActive: true
        )
    }()

    static let mockTender: PortTimer = {
        let calendar = Calendar.current
        let allAboard = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: .now)!
        let lastTender = calendar.date(bySettingHour: 15, minute: 30, second: 0, of: .now)!
        return PortTimer(
            portName: "Grand Cayman",
            allAboardTime: allAboard,
            mode: .tender,
            bufferMinutes: 90,
            lastTenderBack: lastTender,
            isActive: false
        )
    }()

    static let mockRecent: [PortTimer] = [mockActive, mockTender]
}

extension CrewMember {
    static let mockCrew: [CrewMember] = [
        .init(name: "You", joinedAt: .now, isHost: true),
        .init(name: "Alex", joinedAt: .now.addingTimeInterval(-3600)),
        .init(name: "Sam", joinedAt: .now.addingTimeInterval(-1800)),
    ]
}
