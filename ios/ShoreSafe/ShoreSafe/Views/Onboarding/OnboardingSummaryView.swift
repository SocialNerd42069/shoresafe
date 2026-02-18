import SwiftUI

struct OnboardingSummaryView: View {
    @ObservedObject var viewModel: TripSetupViewModel
    let onComplete: () -> Void

    var body: some View {
        SSOnboardingPage(step: 6, totalSteps: viewModel.totalSteps) {
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

                Text("Here's your trip setup.\nYou can change everything later.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.lg)

            // Summary card
            SSGlassCard(padding: SSSpacing.md) {
                VStack(spacing: SSSpacing.sm) {
                    if !viewModel.tripName.isEmpty {
                        SummaryRow(icon: "globe.americas", label: "Trip", value: viewModel.tripName)
                        SummaryDivider()
                    }

                    if let line = viewModel.cruiseLine {
                        SummaryRow(icon: "ferry", label: "Cruise line", value: line)
                        SummaryDivider()
                    }

                    SummaryRow(
                        icon: "clock.badge.exclamationmark",
                        label: "Ship time",
                        value: viewModel.offsetHours == 0 ? "Same as local" : (viewModel.offsetHours > 0 ? "+\(viewModel.offsetHours)h" : "\(viewModel.offsetHours)h")
                    )
                    SummaryDivider()

                    SummaryRow(
                        icon: "mappin.and.ellipse",
                        label: "Ports",
                        value: viewModel.ports.isEmpty ? "None yet" : "\(viewModel.ports.count) port\(viewModel.ports.count == 1 ? "" : "s")"
                    )

                    if !viewModel.ports.filter({ !$0.hasRequiredTimes }).isEmpty {
                        HStack(spacing: SSSpacing.xs) {
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 12))
                            Text("Some ports need times — you can add them from the home screen")
                                .font(.ssCaptionSmall)
                        }
                        .foregroundStyle(Color.ssSunrise.opacity(0.8))
                        .padding(.top, SSSpacing.xs)
                    }

                    SummaryDivider()

                    SummaryRow(
                        icon: "gauge.with.needle",
                        label: "Buffer style",
                        value: viewModel.bufferPersona.rawValue
                    )
                    SummaryDivider()

                    SummaryRow(
                        icon: "bell.badge",
                        label: "Alerts",
                        value: "\(viewModel.warningIntervals.count + 1) scheduled"
                    )
                    SummaryDivider()

                    SummaryRow(
                        icon: viewModel.notificationsGranted ? "bell.fill" : "bell.slash",
                        label: "Notifications",
                        value: viewModel.notificationsGranted ? "Enabled" : "Off"
                    )
                }
            }

            Spacer()

            VStack(spacing: SSSpacing.md) {
                SSButton(title: "Start my cruise", icon: "sun.and.horizon") {
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
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.ssCoral)
                .frame(width: 20)

            Text(label)
                .font(.ssBodySmall)
                .foregroundStyle(Color.ssTextMuted)

            Spacer()

            Text(value)
                .font(.ssBodyMedium)
                .foregroundStyle(.white)
        }
    }
}

private struct SummaryDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.06))
            .frame(height: 1)
    }
}
