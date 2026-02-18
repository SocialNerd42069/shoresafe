import SwiftUI

struct OnboardingWarningsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    private let allWarnings = [90, 60, 30, 15, 5]

    var body: some View {
        SSOnboardingPage(step: 5, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssSunrise.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "bell.badge")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssSunrise)
                }

                Text("Your alert\nschedule")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Choose when we nudge you before\nit's time to head back.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.xl)

            VStack(spacing: SSSpacing.sm) {
                ForEach(allWarnings, id: \.self) { minutes in
                    Button {
                        withAnimation(.spring(response: 0.25)) {
                            viewModel.toggleWarning(minutes)
                        }
                    } label: {
                        WarningRow(
                            minutes: minutes,
                            isSelected: viewModel.data.warningIntervals.contains(minutes)
                        )
                    }
                    .buttonStyle(.plain)
                }

                // Always-on row
                WarningRow(minutes: 0, isSelected: true, isLocked: true)
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

// MARK: - Warning Row

private struct WarningRow: View {
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
        HStack(spacing: SSSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 24)

            Text(label)
                .font(.ssBodyMedium)

            Spacer()

            if isLocked {
                Text("Always on")
                    .font(.ssCaptionSmall)
                    .foregroundStyle(Color.ssTextMuted)
            } else {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted.opacity(0.4))
                    .font(.title3)
            }
        }
        .foregroundStyle(isSelected ? Color.ssTextOnDark : Color.ssTextMuted)
        .padding(.horizontal, SSSpacing.md)
        .padding(.vertical, 12)
        .background(isSelected ? Color.ssCoral.opacity(0.08) : Color.ssGlass)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.md)
                .stroke(
                    isSelected ? Color.ssCoral.opacity(0.3) : Color.ssGlassBorder,
                    lineWidth: 1
                )
        }
    }
}
