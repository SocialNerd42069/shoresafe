import SwiftUI

struct OnboardingCruiseLineView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        SSOnboardingPage(step: 2, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                Image(systemName: "ferry.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.ssSea)

                Text("Which cruise line?")
                    .ssOnboardingTitle()

                Text("Optional — helps us tailor your experience.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: SSSpacing.xl)

            LazyVGrid(columns: columns, spacing: SSSpacing.md) {
                ForEach(CruiseLine.popular) { line in
                    Button {
                        viewModel.selectCruiseLine(line.name)
                    } label: {
                        HStack(spacing: SSSpacing.sm) {
                            Image(systemName: line.icon)
                                .font(.ssCaption)
                            Text(line.name)
                                .font(.ssChip)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isSelected(line) ? .white : .white.opacity(0.7))
                        .background(isSelected(line) ? Color.ssCoral : Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
                        .overlay {
                            if !isSelected(line) {
                                RoundedRectangle(cornerRadius: SSRadius.md)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            HStack(spacing: SSSpacing.md) {
                SSButton(title: "Skip", style: .ghost) {
                    viewModel.next()
                }
                .frame(width: 100)

                SSButton(title: "Next", icon: "arrow.right") {
                    viewModel.next()
                }
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }

    private func isSelected(_ line: CruiseLine) -> Bool {
        viewModel.data.cruiseLine == line.name
    }
}
