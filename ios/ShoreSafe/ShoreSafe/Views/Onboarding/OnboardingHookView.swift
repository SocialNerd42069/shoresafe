import SwiftUI

struct OnboardingHookView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false

    var body: some View {
        SSOnboardingPage(step: 0, totalSteps: viewModel.totalSteps) {
            Spacer()

            VStack(spacing: SSSpacing.xl) {
                // Hero — glowing ship icon
                ZStack {
                    // Ambient glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.ssCoral.opacity(0.25), Color.ssCoral.opacity(0.0)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)

                    // Icon ring
                    Circle()
                        .fill(Color.ssGlassLight)
                        .frame(width: 130, height: 130)
                        .overlay {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.ssCoral.opacity(0.5), Color.ssSunrise.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }

                    Image(systemName: "ferry.fill")
                        .font(.system(size: 52, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.ssCoral, .ssSunrise],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                }

                VStack(spacing: SSSpacing.md) {
                    Text("Never miss\nthe ship.")
                        .ssOnboardingTitle()
                        .multilineTextAlignment(.center)
                        .opacity(showTitle ? 1 : 0)
                        .offset(y: showTitle ? 0 : 16)

                    Text("Ship time drifts from local time at every port.\nShoreSafe keeps you synced so you always\nmake it back.")
                        .ssOnboardingBody()
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 12)
                }
            }

            Spacer()
            Spacer()

            SSButton(title: "Get started", icon: "arrow.right") {
                viewModel.next()
            }
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 20)
            .padding(.bottom, SSSpacing.xxl)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) { showTitle = true }
            withAnimation(.easeOut(duration: 0.6).delay(0.5)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showButton = true }
        }
    }
}
