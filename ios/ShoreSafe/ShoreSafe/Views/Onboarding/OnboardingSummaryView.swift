import SwiftUI

struct OnboardingSummaryView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    var body: some View {
        SSOnboardingPage(step: 7, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssSuccess.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.ssSuccess)
                }

                Text("You're all set")
                    .ssOnboardingTitle()

                Text("Your perfect day ashore starts with one simple timer.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: SSSpacing.xl)

            // Summary card
            VStack(alignment: .leading, spacing: SSSpacing.md) {
                SummaryRow(
                    icon: "calendar",
                    label: "Cruise date",
                    value: viewModel.data.cruiseDate.formatted(date: .abbreviated, time: .omitted)
                )

                if let line = viewModel.data.cruiseLine {
                    SummaryRow(icon: "ferry", label: "Cruise line", value: line)
                }

                SummaryRow(
                    icon: "gauge.with.needle",
                    label: "Buffer style",
                    value: viewModel.data.bufferPersona.rawValue
                )

                SummaryRow(
                    icon: "bell.badge",
                    label: "Alerts",
                    value: "\(viewModel.data.warningIntervals.count + 1) scheduled"
                )

                SummaryRow(
                    icon: viewModel.data.notificationsGranted ? "bell.fill" : "bell.slash",
                    label: "Notifications",
                    value: viewModel.data.notificationsGranted ? "Enabled" : "Off"
                )
            }
            .padding(SSSpacing.cardPadding)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))

            Spacer()

            VStack(spacing: SSSpacing.md) {
                SSButton(title: "Plan my first port day", icon: "sun.and.horizon") {
                    onComplete()
                }

                SSButton(title: "Back", style: .ghost) {
                    viewModel.back()
                }
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}

// MARK: - Summary Row

private struct SummaryRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: SSSpacing.md) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.ssCoral)
                .frame(width: 24)

            Text(label)
                .font(.ssBodySmall)
                .foregroundStyle(Color.ssTextMuted)

            Spacer()

            Text(value)
                .font(.ssBodyMedium)
                .foregroundStyle(Color.ssTextOnDark)
        }
    }
}
