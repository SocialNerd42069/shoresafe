import Foundation

// MARK: - Onboarding Data

struct OnboardingData {
    var cruiseDate: Date = .now
    var cruiseLine: String? = nil
    var shipName: String? = nil
    var bufferPersona: BufferPersona = .balanced
    var warningIntervals: Set<Int> = [90, 60, 30, 15, 5]
    var notificationsGranted: Bool = false
}

// MARK: - Buffer Persona

enum BufferPersona: String, CaseIterable, Identifiable {
    case safetyNet = "Safety Net"
    case balanced = "Balanced"
    case thrillSeeker = "Thrill Seeker"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .safetyNet: "shield.checkered"
        case .balanced: "scalemass"
        case .thrillSeeker: "bolt.fill"
        }
    }

    var dockBuffer: Int {
        switch self {
        case .safetyNet: 90
        case .balanced: 60
        case .thrillSeeker: 30
        }
    }

    var tenderBuffer: Int {
        switch self {
        case .safetyNet: 120
        case .balanced: 90
        case .thrillSeeker: 60
        }
    }

    var tagline: String {
        switch self {
        case .safetyNet: "Extra margin, zero stress"
        case .balanced: "Sweet spot for most cruisers"
        case .thrillSeeker: "Every minute counts ashore"
        }
    }

    var defaultWarnings: Set<Int> {
        switch self {
        case .safetyNet: [90, 60, 30, 15, 5]
        case .balanced: [60, 30, 15, 5]
        case .thrillSeeker: [30, 15, 5]
        }
    }
}

// MARK: - Cruise Lines (chip data)

struct CruiseLine: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String // SF Symbol

    static let popular: [CruiseLine] = [
        .init(name: "Royal Caribbean", icon: "crown"),
        .init(name: "Carnival", icon: "party.popper"),
        .init(name: "Norwegian", icon: "sailboat"),
        .init(name: "MSC", icon: "globe.europe.africa"),
        .init(name: "Celebrity", icon: "star"),
        .init(name: "Disney", icon: "sparkles"),
        .init(name: "Princess", icon: "tiara"),
        .init(name: "Holland America", icon: "flag"),
        .init(name: "Virgin Voyages", icon: "v.circle"),
    ]
}
