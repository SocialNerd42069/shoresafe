import Foundation

// MARK: - Trip

struct Trip: Codable, Identifiable {
    var id = UUID()
    var name: String
    var cruiseLine: String?
    var sailDate: Date?
    var returnDate: Date?
    var shipTimeConfig: ShipTimeConfig
    var ports: [Port]
    var bufferPersona: BufferPersona
    var warningIntervals: Set<Int>
    var notificationsGranted: Bool

    static let empty = Trip(
        name: "",
        cruiseLine: nil,
        sailDate: nil,
        returnDate: nil,
        shipTimeConfig: .local,
        ports: [],
        bufferPersona: .balanced,
        warningIntervals: [60, 30, 15, 5],
        notificationsGranted: false
    )
}

// MARK: - Ship Time Config

enum ShipTimeConfig: Codable, Equatable {
    case local // Ship time = phone time (same zone)
    case offset(hours: Int) // Ship is +/- N hours from phone

    var isLocal: Bool {
        if case .local = self { return true }
        return false
    }

    var offsetHours: Int {
        switch self {
        case .local: return 0
        case .offset(let h): return h
        }
    }

    var displayLabel: String {
        switch self {
        case .local:
            return "Same as local"
        case .offset(let h):
            if h > 0 { return "Ship is +\(h)h ahead" }
            if h < 0 { return "Ship is \(h)h behind" }
            return "Same as local"
        }
    }
}

// MARK: - Port

struct Port: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var date: Date?
    var allAboardTime: Date? // nil = unknown, user fills later
    var lastTenderTime: Date? // nil = not applicable or unknown
    var mode: PortMode
    var customBufferMinutes: Int? // nil = use trip default

    var hasRequiredTimes: Bool {
        allAboardTime != nil
    }

    var displayDate: String {
        guard let date else { return "Date TBD" }
        return date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }

    static func placeholder(name: String, date: Date? = nil) -> Port {
        Port(name: name, date: date, allAboardTime: nil, lastTenderTime: nil, mode: .dock, customBufferMinutes: nil)
    }
}

// MARK: - PortMode Codable

extension PortMode: Codable {}

// MARK: - BufferPersona Codable

extension BufferPersona: Codable {}
