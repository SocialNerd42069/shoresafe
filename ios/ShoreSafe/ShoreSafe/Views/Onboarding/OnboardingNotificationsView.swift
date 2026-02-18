import SwiftUI

struct OnboardingNotificationsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        SSOnboardingPage(step: 6, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssCoral.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.ssCoral)
                        .symbolEffect(.pulse)
                }

                Text("Stay in the loop")
                    .ssOnboardingTitle()

                Text("ShoreSafe sends calm, timely reminders as your 'head back' time approaches. No spam — just the alerts you picked.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SSSpacing.sm)

                // Preview of what alerts look like
                VStack(spacing: SSSpacing.sm) {
                    NotificationPreview(time: "2:30 PM", text: "60 minutes until head-back time")
                    NotificationPreview(time: "3:00 PM", text: "30 minutes — start wrapping up")
                    NotificationPreview(time: "3:15 PM", text: "15 minutes — head back now")
                }
                .padding(.top, SSSpacing.md)
            }

            Spacer()
            Spacer()

            VStack(spacing: SSSpacing.md) {
                SSButton(title: "Turn on notifications", icon: "bell") {
                    // Placeholder: would request UNUserNotificationCenter permission
                    viewModel.data.notificationsGranted = true
                    viewModel.next()
                }

                SSButton(title: "Not now", style: .ghost) {
                    viewModel.next()
                }
            }
            .padding(.bottom, SSSpacing.xxl)
        }
    }
}

// MARK: - Notification Preview

private struct NotificationPreview: View {
    let time: String
    let text: String

    var body: some View {
        HStack(spacing: SSSpacing.sm) {
            Image(systemName: "sun.and.horizon.fill")
                .font(.caption)
                .foregroundStyle(Color.ssCoral)
                .frame(width: 24, height: 24)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))

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
        .padding(SSSpacing.sm)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
    }
}
