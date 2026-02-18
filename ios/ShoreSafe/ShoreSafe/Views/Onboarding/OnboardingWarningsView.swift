import SwiftUI

struct OnboardingWarningsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    private let allWarnings = [90, 60, 30, 15, 5]

    var body: some View {
        SSOnboardingPage(step: 5, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.ssSunrise)

                Text("Alert schedule")
                    .ssOnboardingTitle()

                Text("We'll nudge you at these intervals before your 'head back' time. Adjust any time.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: SSSpacing.xl)

            VStack(spacing: SSSpacing.md) {
                ForEach(allWarnings, id: \.self) { minutes in
                    Button {
                        withAnimation(.spring(response: 0.25)) {
                            viewModel.toggleWarning(minutes)
                        }
                    } label: {
                        WarningChipRow(
                            minutes: minutes,
                            isSelected: viewModel.data.warningIntervals.contains(minutes)
                        )
                    }
                    .buttonStyle(.plain)
                }

                // "Head back now" is always on
                WarningChipRow(minutes: 0, isSelected: true, isLocked: true)
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

// MARK: - Warning Chip Row

private struct WarningChipRow: View {
    let minutes: Int
    let isSelected: Bool
    var isLocked: Bool = false

    private var label: String {
        minutes == 0 ? "Head back now" : "\(minutes) min before"
    }

    private var icon: String {
        switch minutes {
        case 90: "gauge.low"
        case 60: "gauge.medium"
        case 30: "gauge.high"
        case 15: "exclamationmark.triangle"
        case 5: "exclamationmark.2"
        default: "bell.and.waves.left.and.right"
        }
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .frame(width: 28)

            Text(label)
                .font(.ssBodyMedium)

            Spacer()

            if isLocked {
                Text("Always on")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(Color.ssTextMuted)
            } else {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted)
            }
        }
        .foregroundStyle(isSelected ? Color.ssTextOnDark : Color.ssTextMuted)
        .padding(.horizontal, SSSpacing.md)
        .padding(.vertical, 12)
        .background(isSelected ? Color.ssCoral.opacity(0.1) : Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
    }
}
