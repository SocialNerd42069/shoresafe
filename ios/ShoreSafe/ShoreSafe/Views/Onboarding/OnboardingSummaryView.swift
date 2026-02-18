import SwiftUI

struct OnboardingSummaryView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    var body: some View {
        SSOnboardingPage(step: 7, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.lg) {
                // Success icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.ssSuccess.opacity(0.2), Color.clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)
                        .blur(radius: 12)

                    Circle()
                        .fill(Color.ssGlassLight)
                        .frame(width: 90, height: 90)
                        .overlay {
                            Circle()
                                .stroke(Color.ssSuccess.opacity(0.3), lineWidth: 1)
                        }

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 38, weight: .medium))
                        .foregroundStyle(Color.ssSuccess)
                }

                Text("Ready to sail")
                    .ssOnboardingTitle()

                Text("Here's your setup. You can tweak\neverything in settings later.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.lg)

            // Summary card
            SSGlassCard(padding: SSSpacing.md) {
                VStack(spacing: SSSpacing.md) {
                    SummaryRow(
                        icon: "calendar",
                        label: "Cruise date",
                        value: viewModel.data.cruiseDate.formatted(date: .abbreviated, time: .omitted)
                    )

                    if let line = viewModel.data.cruiseLine {
                        Divider().background(Color.white.opacity(0.1))
                        SummaryRow(icon: "ferry", label: "Cruise line", value: line)
                    }

                    Divider().background(Color.white.opacity(0.1))
                    SummaryRow(
                        icon: "gauge.with.needle",
                        label: "Buffer style",
                        value: viewModel.data.bufferPersona.rawValue
                    )

                    Divider().background(Color.white.opacity(0.1))
                    SummaryRow(
                        icon: "bell.badge",
                        label: "Alerts",
                        value: "\(viewModel.data.warningIntervals.count + 1) scheduled"
                    )

                    Divider().background(Color.white.opacity(0.1))
                    SummaryRow(
                        icon: viewModel.data.notificationsGranted ? "bell.fill" : "bell.slash",
                        label: "Notifications",
                        value: viewModel.data.notificationsGranted ? "Enabled" : "Off"
                    )
                }
            }

            Spacer()

            VStack(spacing: SSSpacing.md) {
                SSButton(title: "Plan my first port day", icon: "sun.and.horizon") {
                    onComplete()
                }

                Button {
                    viewModel.back()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Back")
                            .font(.ssBodyMedium)
                    }
                    .foregroundStyle(Color.white.opacity(0.4))
                }
                .buttonStyle(.plain)
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
                .font(.system(size: 16, weight: .medium))
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
