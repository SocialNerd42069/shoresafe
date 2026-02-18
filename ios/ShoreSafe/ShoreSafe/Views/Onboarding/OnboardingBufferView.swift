import SwiftUI

struct OnboardingBufferView: View {
    @ObservedObject var viewModel: OnboardingViewModel

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

                Text("How early should\nwe alert you?")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Pick your comfort level. We'll set your\nhead-back buffer for dock and tender ports.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.xl)

            VStack(spacing: SSSpacing.sm) {
                ForEach(BufferPersona.allCases) { persona in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectPersona(persona)
                        }
                    } label: {
                        PersonaCard(
                            persona: persona,
                            isSelected: viewModel.data.bufferPersona == persona
                        )
                    }
                    .buttonStyle(.plain)
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
            // Icon
            ZStack {
                Circle()
                    .fill(isSelected ? Color.ssCoral.opacity(0.15) : Color.ssGlass)
                    .frame(width: 44, height: 44)
                Image(systemName: persona.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted)
            }

            VStack(alignment: .leading, spacing: SSSpacing.xs) {
                Text(persona.rawValue)
                    .font(.ssSubheadline)
                    .foregroundStyle(Color.ssTextOnDark)

                Text(persona.tagline)
                    .font(.ssBodySmall)
                    .foregroundStyle(Color.ssTextMuted)

                HStack(spacing: SSSpacing.md) {
                    Label("Dock \(persona.dockBuffer)m", systemImage: "arrow.down.to.line")
                    Label("Tender \(persona.tenderBuffer)m", systemImage: "ferry")
                }
                .font(.ssCaptionSmall)
                .foregroundStyle(Color.ssSea)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted.opacity(0.5))
                .font(.title3)
        }
        .padding(SSSpacing.md)
        .background(isSelected ? Color.ssCoral.opacity(0.08) : Color.ssGlass)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.lg)
                .stroke(
                    isSelected ? Color.ssCoral.opacity(0.4) : Color.ssGlassBorder,
                    lineWidth: 1
                )
        }
    }
}
