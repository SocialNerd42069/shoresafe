import SwiftUI

/// Theme-aware variant of the onboarding hook screen for screenshot generation.
struct ThemedHookView: View {
    @ObservedObject var viewModel: TripSetupViewModel
    @Environment(\.ssTheme) private var theme

    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false

    var body: some View {
        ZStack {
            // Background layer
            backgroundLayer
                .ignoresSafeArea()

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

                        Image(systemName: theme.hookHeroIcon)
                            .font(.system(size: theme.hookHeroIconSize, weight: .medium))
                            .foregroundStyle(theme.heroIconGradient)
                    }

                    VStack(spacing: SSSpacing.md) {
                        Text(theme.hookTitleText)
                            .font(.system(size: 36, weight: .bold, design: theme.displayDesign))
                            .foregroundStyle(theme.hookTitleColor)
                            .tracking(-0.5)
                            .multilineTextAlignment(.center)
                            .opacity(showTitle ? 1 : 0)
                            .offset(y: showTitle ? 0 : 16)

                        Text(theme.hookSubtitleText)
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
                        Text(theme.hookCTAText)
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
        }
        .preferredColorScheme(theme.colorScheme)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) { showTitle = true }
            withAnimation(.easeOut(duration: 0.6).delay(0.5)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showButton = true }
        }
    }

    // MARK: - Background

    @ViewBuilder
    private var backgroundLayer: some View {
        if theme.hookUsesImageBackground,
           let imageName = theme.heroImageName,
           let uiImage = UIImage(named: imageName) {
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                // Dark overlay for readability
                Rectangle()
                    .fill(Color.black.opacity(theme.hookOverlayOpacity))

                // Subtle gradient overlay from bottom for text contrast
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(theme.hookOverlayOpacity * 0.6)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
        } else {
            Rectangle().fill(theme.hookBackground)
        }
    }

    // MARK: - Progress Bar

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
