import SwiftUI

@MainActor
final class TripStore: ObservableObject {
    @Published var currentTrip: Trip?
    @Published var purchaseTier: PurchaseTier = .none

    private let tripKey = "ss_current_trip"

    init() {
        load()
    }

    func save(_ trip: Trip) {
        currentTrip = trip
        if let data = try? JSONEncoder().encode(trip) {
            UserDefaults.standard.set(data, forKey: tripKey)
        }
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: tripKey),
              let trip = try? JSONDecoder().decode(Trip.self, from: data) else {
            return
        }
        currentTrip = trip
    }

    func updatePort(_ port: Port) {
        guard var trip = currentTrip,
              let idx = trip.ports.firstIndex(where: { $0.id == port.id }) else { return }
        trip.ports[idx] = port
        save(trip)
    }

    func clearTrip() {
        currentTrip = nil
        UserDefaults.standard.removeObject(forKey: tripKey)
    }

    // MARK: - Port day helpers

    var todayPort: Port? {
        guard let trip = currentTrip else { return nil }
        let cal = Calendar.current
        return trip.ports.first { port in
            guard let date = port.date else { return false }
            return cal.isDate(date, inSameDayAs: .now)
        }
    }

    var nextPort: Port? {
        guard let trip = currentTrip else { return nil }
        let cal = Calendar.current
        let now = Date.now
        return trip.ports
            .filter { port in
                guard let date = port.date else { return false }
                return cal.compare(date, to: now, toGranularity: .day) != .orderedAscending
            }
            .sorted { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) }
            .first
    }

    var portsNeedingTimes: [Port] {
        currentTrip?.ports.filter { !$0.hasRequiredTimes } ?? []
    }

    func shipTimeAdjusted(_ date: Date) -> Date {
        guard let trip = currentTrip else { return date }
        let offset = trip.shipTimeConfig.offsetHours
        return date.addingTimeInterval(Double(offset) * 3600)
    }

    func countdownToAllAboard(for port: Port) -> TimeInterval? {
        guard let allAboard = port.allAboardTime else { return nil }
        let buffer = port.customBufferMinutes ?? currentTrip?.bufferPersona.dockBuffer ?? 60
        let beBackBy = allAboard.addingTimeInterval(-Double(buffer) * 60)
        return beBackBy.timeIntervalSinceNow
    }
}
