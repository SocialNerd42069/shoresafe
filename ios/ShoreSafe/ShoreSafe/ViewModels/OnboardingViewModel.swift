import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var data = OnboardingData()
    @Published var isComplete = false

    let totalSteps = 8

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

    func selectPersona(_ persona: BufferPersona) {
        data.bufferPersona = persona
        data.warningIntervals = persona.defaultWarnings
    }

    func toggleWarning(_ minutes: Int) {
        if data.warningIntervals.contains(minutes) {
            data.warningIntervals.remove(minutes)
        } else {
            data.warningIntervals.insert(minutes)
        }
    }

    func selectCruiseLine(_ name: String) {
        data.cruiseLine = data.cruiseLine == name ? nil : name
    }
}
