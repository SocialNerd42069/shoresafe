import SwiftUI

/// Theme-aware variant of the onboarding hook screen for screenshot generation.
struct ThemedHookView: View {
    @ObservedObject var viewModel: TripSetupViewModel
    @Environment(\.ssTheme) private var theme

    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            themedProgressBar
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.top, SSSpacing.md)
                .padding(.bottom, SSSpacing.lg)

            Spacer()

            VStack(spacing: SSSpacing.xl) {
                // Hero icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: theme.heroGlowColors,
                                center: .center,
                                startRadius: 10,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)

                    Circle()
                        .fill(theme.heroCircleFill)
                        .frame(width: 130, height: 130)
                        .overlay {
                            Circle()
                                .stroke(theme.heroCircleBorder, lineWidth: 1)
                        }

                    Image(systemName: "ferry.fill")
                        .font(.system(size: 52, weight: .medium))
                        .foregroundStyle(theme.heroIconGradient)
                }

                VStack(spacing: SSSpacing.md) {
                    Text("Never miss\nthe ship.")
                        .font(.system(size: 36, weight: .bold, design: theme.displayDesign))
                        .foregroundStyle(theme.hookTitleColor)
                        .tracking(-0.5)
                        .multilineTextAlignment(.center)
                        .opacity(showTitle ? 1 : 0)
                        .offset(y: showTitle ? 0 : 16)

                    Text("Set up your cruise in 60 seconds.\nPierRunner tracks every port day so you\nalways make it back on time.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(theme.hookBodyColor)
                        .tracking(0.1)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 12)
                }
            }

            Spacer()
            Spacer()

            // CTA button
            Button {
                viewModel.next()
            } label: {
                HStack(spacing: SSSpacing.sm) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Set up my cruise")
                        .font(.ssSubheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .padding(.horizontal, SSSpacing.lg)
                .foregroundStyle(theme.buttonForeground)
                .background(theme.buttonBackground)
                .clipShape(RoundedRectangle(cornerRadius: theme.buttonRadius))
            }
            .buttonStyle(.plain)
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 20)
            .padding(.horizontal, SSSpacing.screenHorizontal)
            .padding(.bottom, SSSpacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.hookBackground)
        .preferredColorScheme(theme.colorScheme)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) { showTitle = true }
            withAnimation(.easeOut(duration: 0.6).delay(0.5)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showButton = true }
        }
    }

    private var themedProgressBar: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= 0 ? theme.progressFill : theme.progressTrack)
                    .frame(height: 3)
            }
        }
    }
}
