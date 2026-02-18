import SwiftUI

@MainActor
final class TripSetupViewModel: ObservableObject {
    // MARK: - Flow state
    @Published var currentStep = 0
    @Published var isComplete = false

    let totalSteps = 7 // welcome, trip info, ship time, ports, buffer, notifications, summary

    // MARK: - Trip data
    @Published var tripName = ""
    @Published var cruiseLine: String? = nil
    @Published var sailDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    @Published var returnDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: .now) ?? .now

    // MARK: - Ship time
    @Published var shipTimeMode: ShipTimeConfig = .local
    @Published var offsetHours: Int = 0

    // MARK: - Ports
    @Published var ports: [Port] = []
    @Published var importText = ""

    // MARK: - Buffer / Alerts
    @Published var bufferPersona: BufferPersona = .balanced
    @Published var warningIntervals: Set<Int> = [60, 30, 15, 5]

    // MARK: - Notifications
    @Published var notificationsGranted = false

    // MARK: - Navigation

    func next() {
        if currentStep < totalSteps - 1 {
            withAnimation(.spring(response: 0.4)) {
                currentStep += 1
            }
        } else {
            isComplete = true
        }
    }

    func back() {
        if currentStep > 0 {
            withAnimation(.spring(response: 0.4)) {
                currentStep -= 1
            }
        }
    }

    func goTo(_ step: Int) {
        withAnimation(.spring(response: 0.4)) {
            currentStep = step
        }
    }

    // MARK: - Port management

    func addPort(name: String, date: Date? = nil) {
        let port = Port.placeholder(name: name, date: date)
        ports.append(port)
    }

    func removePort(at index: Int) {
        guard ports.indices.contains(index) else { return }
        ports.remove(at: index)
    }

    func updatePortTime(id: UUID, allAboard: Date?, lastTender: Date? = nil) {
        guard let idx = ports.firstIndex(where: { $0.id == id }) else { return }
        ports[idx].allAboardTime = allAboard
        ports[idx].lastTenderTime = lastTender
    }

    // MARK: - Import itinerary (best-effort text parsing)

    func parseImportedItinerary() {
        let lines = importText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var parsed: [Port] = []
        let dateFormatter = DateFormatter()
        let dateFormats = ["MMM d", "MMMM d", "MM/dd", "M/d", "d MMM", "d MMMM"]

        for line in lines {
            // Try to extract a date and port name
            var foundDate: Date? = nil
            var portName = line

            // Remove common prefixes like "Day 1:", "1.", bullets
            let cleaned = line
                .replacingOccurrences(of: #"^(Day\s*\d+\s*[:\-]?\s*|^\d+\.\s*|^[\-\*\u2022]\s*)"#, with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespaces)

            // Try to find a date pattern in the line
            for fmt in dateFormats {
                dateFormatter.dateFormat = fmt
                // Try matching at the end of the string
                let parts = cleaned.components(separatedBy: " - ")
                if parts.count >= 2 {
                    // "Port Name - Jan 15" or "Jan 15 - Port Name"
                    if let d = dateFormatter.date(from: parts.last!.trimmingCharacters(in: .whitespaces)) {
                        foundDate = setYear(d)
                        portName = parts.dropLast().joined(separator: " - ").trimmingCharacters(in: .whitespaces)
                        break
                    }
                    if let d = dateFormatter.date(from: parts.first!.trimmingCharacters(in: .whitespaces)) {
                        foundDate = setYear(d)
                        portName = parts.dropFirst().joined(separator: " - ").trimmingCharacters(in: .whitespaces)
                        break
                    }
                }
            }

            if portName.isEmpty { portName = cleaned }

            // Skip "Sea Day" / "At Sea" entries
            let lower = portName.lowercased()
            if lower.contains("sea day") || lower == "at sea" || lower.contains("embarkation") || lower.contains("disembarkation") {
                continue
            }

            parsed.append(Port.placeholder(name: portName, date: foundDate))
        }

        if !parsed.isEmpty {
            ports.append(contentsOf: parsed)
        }
    }

    private func setYear(_ date: Date) -> Date {
        let cal = Calendar.current
        var comps = cal.dateComponents([.month, .day], from: date)
        comps.year = cal.component(.year, from: sailDate)
        return cal.date(from: comps) ?? date
    }

    // MARK: - Buffer persona

    func selectPersona(_ persona: BufferPersona) {
        bufferPersona = persona
        warningIntervals = persona.defaultWarnings
    }

    func toggleWarning(_ minutes: Int) {
        if warningIntervals.contains(minutes) {
            warningIntervals.remove(minutes)
        } else {
            warningIntervals.insert(minutes)
        }
    }

    func selectCruiseLine(_ name: String) {
        cruiseLine = cruiseLine == name ? nil : name
    }

    // MARK: - Build Trip

    func buildTrip() -> Trip {
        let config: ShipTimeConfig = offsetHours == 0 ? .local : .offset(hours: offsetHours)
        return Trip(
            name: tripName.isEmpty ? (cruiseLine ?? "My Cruise") : tripName,
            cruiseLine: cruiseLine,
            sailDate: sailDate,
            returnDate: returnDate,
            shipTimeConfig: config,
            ports: ports,
            bufferPersona: bufferPersona,
            warningIntervals: warningIntervals,
            notificationsGranted: notificationsGranted
        )
    }
}
