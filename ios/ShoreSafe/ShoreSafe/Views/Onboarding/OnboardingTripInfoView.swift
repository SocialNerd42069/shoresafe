import SwiftUI

struct OnboardingTripInfoView: View {
    @ObservedObject var viewModel: TripSetupViewModel

    let columns = [
        GridItem(.flexible(), spacing: SSSpacing.sm),
        GridItem(.flexible(), spacing: SSSpacing.sm),
    ]

    var body: some View {
        SSOnboardingPage(step: 1, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssSea.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "globe.americas")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssSea)
                }

                Text("Your cruise")
                    .ssOnboardingTitle()

                Text("Tell us about your trip.\nEverything here is optional.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.lg)

            VStack(spacing: SSSpacing.md) {
                // Cruise name
                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text("CRUISE NAME")
                        .font(.ssOverline)
                        .foregroundStyle(Color.ssTextMuted)
                        .tracking(1.5)
                    TextField("e.g. Western Caribbean 2026", text: $viewModel.tripName)
                        .font(.ssBody)
                        .foregroundStyle(.white)
                        .padding(SSSpacing.md)
                        .background(Color.ssGlass)
                        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
                        .overlay {
                            RoundedRectangle(cornerRadius: SSRadius.md)
                                .stroke(Color.ssGlassBorder, lineWidth: 1)
                        }
                }

                // Cruise line chips
                VStack(alignment: .leading, spacing: SSSpacing.sm) {
                    Text("CRUISE LINE")
                        .font(.ssOverline)
                        .foregroundStyle(Color.ssTextMuted)
                        .tracking(1.5)

                    LazyVGrid(columns: columns, spacing: SSSpacing.xs) {
                        ForEach(CruiseLine.popular) { line in
                            Button {
                                withAnimation(.spring(response: 0.25)) {
                                    viewModel.selectCruiseLine(line.name)
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: line.icon)
                                        .font(.system(size: 10, weight: .medium))
                                        .frame(width: 14)
                                    Text(line.name)
                                        .font(.ssChip)
                                        .lineLimit(1)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 9)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(isSelected(line) ? .white : .white.opacity(0.6))
                                .background(isSelected(line) ? Color.ssCoral : Color.ssGlass)
                                .clipShape(RoundedRectangle(cornerRadius: SSRadius.sm))
                                .overlay {
                                    if !isSelected(line) {
                                        RoundedRectangle(cornerRadius: SSRadius.sm)
                                            .stroke(Color.ssGlassBorder, lineWidth: 1)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
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

    private func isSelected(_ line: CruiseLine) -> Bool {
        viewModel.cruiseLine == line.name
    }
}
