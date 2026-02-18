import SwiftUI

struct OnboardingNotificationsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 6, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.lg) {
                // Glowing bell
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.ssCoral.opacity(0.2), Color.clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .blur(radius: 15)

                    Circle()
                        .fill(Color.ssGlassLight)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Circle()
                                .stroke(Color.ssCoral.opacity(0.3), lineWidth: 1)
                        }

                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundStyle(Color.ssCoral)
                        .symbolEffect(.pulse)
                }

                Text("Don't miss\nthe alerts")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Escalating reminders as all-aboard approaches.\nNo spam — only the alerts you chose.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)

                // Notification previews
                VStack(spacing: SSSpacing.sm) {
                    NotificationPreview(time: "2:30 PM", text: "60 min to all-aboard — no rush yet", opacity: 0.6)
                    NotificationPreview(time: "3:00 PM", text: "30 min — start wrapping up", opacity: 0.8)
                    NotificationPreview(time: "3:15 PM", text: "15 min — head to the gangway", opacity: 1.0)
                }
                .padding(.top, SSSpacing.xs)
            }

            Spacer()
            Spacer()

            VStack(spacing: SSSpacing.md) {
                SSButton(title: "Turn on notifications", icon: "bell") {
                    viewModel.data.notificationsGranted = true
                    viewModel.next()
                }

                Button {
                    viewModel.next()
                } label: {
                    Text("Not now")
                        .font(.ssBodyMedium)
                        .foregroundStyle(Color.white.opacity(0.4))
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}

// MARK: - Notification Preview

private struct NotificationPreview: View {
    let time: String
    let text: String
    var opacity: Double = 1.0

    var body: some View {
        HStack(spacing: SSSpacing.sm) {
            // App icon mini
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.ssCoral.opacity(0.15))
                    .frame(width: 28, height: 28)
                Image(systemName: "ferry.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.ssCoral)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("ShoreSafe")
                        .font(.ssCaptionSmall)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(time)
                        .font(.ssCaptionSmall)
                }
                .foregroundStyle(Color.ssTextMuted)

                Text(text)
                    .font(.ssBodySmall)
                    .foregroundStyle(Color.ssTextOnDark)
            }
        }
        .padding(10)
        .background(Color.ssGlassLight)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.md)
                .stroke(Color.ssGlassBorder, lineWidth: 1)
        }
        .opacity(opacity)
    }
}
