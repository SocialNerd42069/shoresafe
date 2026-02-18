import SwiftUI

struct OnboardingCruiseLineView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    let columns = [
        GridItem(.flexible(), spacing: SSSpacing.sm),
        GridItem(.flexible(), spacing: SSSpacing.sm),
    ]

    var body: some View {
        SSOnboardingPage(step: 3, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssSea.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "ferry.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssSea)
                }

                Text("Which cruise line?")
                    .ssOnboardingTitle()

                Text("Optional — helps personalize your setup.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: SSSpacing.xl)

            LazyVGrid(columns: columns, spacing: SSSpacing.sm) {
                ForEach(CruiseLine.popular) { line in
                    Button {
                        withAnimation(.spring(response: 0.25)) {
                            viewModel.selectCruiseLine(line.name)
                        }
                    } label: {
                        HStack(spacing: SSSpacing.sm) {
                            Image(systemName: line.icon)
                                .font(.system(size: 12, weight: .medium))
                                .frame(width: 16)
                            Text(line.name)
                                .font(.ssChip)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isSelected(line) ? .white : .white.opacity(0.65))
                        .background(isSelected(line) ? Color.ssCoral : Color.ssGlass)
                        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
                        .overlay {
                            if !isSelected(line) {
                                RoundedRectangle(cornerRadius: SSRadius.md)
                                    .stroke(Color.ssGlassBorder, lineWidth: 1)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            SSOnboardingNav(
                backLabel: "Skip",
                nextLabel: "Next",
                onBack: { viewModel.next() },
                onNext: { viewModel.next() }
            )
        }
    }

    private func isSelected(_ line: CruiseLine) -> Bool {
        viewModel.data.cruiseLine == line.name
    }
}
