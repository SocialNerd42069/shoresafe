import SwiftUI

struct OnboardingBufferView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 4, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                Image(systemName: "gauge.with.needle")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.ssCoral)

                Text("How early should\nwe alert you?")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Pick your comfort level. We'll set your head-back buffer for dock and tender ports.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: SSSpacing.xl)

            VStack(spacing: SSSpacing.md) {
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

            HStack(spacing: SSSpacing.md) {
                SSButton(title: "Back", style: .ghost) {
                    viewModel.back()
                }
                .frame(width: 100)

                SSButton(title: "Next", icon: "arrow.right") {
                    viewModel.next()
                }
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}

// MARK: - Persona Card

private struct PersonaCard: View {
    let persona: BufferPersona
    let isSelected: Bool

    var body: some View {
        HStack(spacing: SSSpacing.md) {
            Image(systemName: persona.icon)
                .font(.title2)
                .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: SSSpacing.xs) {
                Text(persona.rawValue)
                    .font(.ssSubheadline)
                    .foregroundStyle(Color.ssTextOnDark)

                Text(persona.tagline)
                    .font(.ssBodySmall)
                    .foregroundStyle(Color.ssTextMuted)

                HStack(spacing: SSSpacing.sm) {
                    Text("Dock: \(persona.dockBuffer)m")
                    Text("Tender: \(persona.tenderBuffer)m")
                }
                .font(.ssCaptionSmall)
                .foregroundStyle(Color.ssSea)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted)
                .font(.title3)
        }
        .padding(SSSpacing.md)
        .background(isSelected ? Color.ssCoral.opacity(0.12) : Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.md)
                .stroke(
                    isSelected ? Color.ssCoral.opacity(0.4) : Color.white.opacity(0.1),
                    lineWidth: 1
                )
        }
    }
}
