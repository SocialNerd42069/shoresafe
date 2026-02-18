import SwiftUI

struct OnboardingBufferView: View {
    @ObservedObject var viewModel: TripSetupViewModel

    private let allWarnings = [90, 60, 30, 15, 5]

    var body: some View {
        SSOnboardingPage(step: 4, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssCoral.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "gauge.with.needle")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssCoral)
                }

                Text("Safety buffer\n& alerts")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Pick your comfort level, then choose\nwhen we send reminders.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.md)

            // Buffer personas
            VStack(spacing: SSSpacing.sm) {
                ForEach(BufferPersona.allCases) { persona in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectPersona(persona)
                        }
                    } label: {
                        PersonaCard(
                            persona: persona,
                            isSelected: viewModel.bufferPersona == persona
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Alert schedule
            VStack(alignment: .leading, spacing: SSSpacing.sm) {
                Text("ALERT SCHEDULE")
                    .font(.ssOverline)
                    .foregroundStyle(Color.ssTextMuted)
                    .tracking(1.5)
                    .padding(.top, SSSpacing.md)

                VStack(spacing: 6) {
                    ForEach(allWarnings, id: \.self) { minutes in
                        Button {
                            withAnimation(.spring(response: 0.25)) {
                                viewModel.toggleWarning(minutes)
                            }
                        } label: {
                            WarningChip(
                                minutes: minutes,
                                isSelected: viewModel.warningIntervals.contains(minutes)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // Always-on
                    WarningChip(minutes: 0, isSelected: true, isLocked: true)
                }
            }

            Spacer()

            SSOnboardingNav(
                backLabel: "Back",
                nextLabel: "Next",
                onBack: { viewModel.back() },
                onNext: { viewModel.next() }
            )
        }
    }
}

// MARK: - Persona Card

private struct PersonaCard: View {
    let persona: BufferPersona
    let isSelected: Bool

    var body: some View {
        HStack(spacing: SSSpacing.md) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.ssCoral.opacity(0.15) : Color.ssGlass)
                    .frame(width: 40, height: 40)
                Image(systemName: persona.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(persona.rawValue)
                    .font(.ssBodyMedium)
                    .foregroundStyle(.white)
                HStack(spacing: SSSpacing.sm) {
                    Text(persona.tagline)
                        .font(.ssCaptionSmall)
                        .foregroundStyle(Color.ssTextMuted)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Dock \(persona.dockBuffer)m")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(Color.ssSea)
                Text("Tender \(persona.tenderBuffer)m")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(Color.ssSea)
            }

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted.opacity(0.4))
                .font(.system(size: 20))
        }
        .padding(.horizontal, SSSpacing.md)
        .padding(.vertical, 10)
        .background(isSelected ? Color.ssCoral.opacity(0.08) : Color.ssGlass)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.md)
                .stroke(isSelected ? Color.ssCoral.opacity(0.4) : Color.ssGlassBorder, lineWidth: 1)
        }
    }
}

// MARK: - Warning Chip

private struct WarningChip: View {
    let minutes: Int
    let isSelected: Bool
    var isLocked: Bool = false

    private var label: String {
        minutes == 0 ? "Head back now" : "\(minutes) min before"
    }

    var body: some View {
        HStack(spacing: SSSpacing.sm) {
            Text(label)
                .font(.ssBodySmall)

            Spacer()

            if isLocked {
                Text("Always on")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(Color.ssTextMuted)
            } else {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted.opacity(0.4))
                    .font(.system(size: 18))
            }
        }
        .foregroundStyle(isSelected ? .white : Color.ssTextMuted)
        .padding(.horizontal, SSSpacing.md)
        .padding(.vertical, 8)
        .background(isSelected ? Color.ssCoral.opacity(0.06) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.sm))
    }
}
