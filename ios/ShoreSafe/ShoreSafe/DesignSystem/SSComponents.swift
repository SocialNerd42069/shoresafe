import SwiftUI

// MARK: - Primary Button

struct SSButton: View {
    let title: String
    var style: Style = .coral
    var icon: String? = nil
    var isCompact: Bool = false
    let action: () -> Void

    enum Style {
        case coral, navy, outline, ghost, glass
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: SSSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: isCompact ? 14 : 16, weight: .semibold))
                }
                Text(title)
                    .font(isCompact ? .ssChip : .ssSubheadline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, isCompact ? 12 : 16)
            .padding(.horizontal, SSSpacing.lg)
            .foregroundStyle(foregroundColor)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: isCompact ? SSRadius.md : SSRadius.xl))
            .overlay {
                if style == .outline {
                    RoundedRectangle(cornerRadius: isCompact ? SSRadius.md : SSRadius.xl)
                        .stroke(Color.ssCoral.opacity(0.6), lineWidth: 1.5)
                }
                if style == .glass {
                    RoundedRectangle(cornerRadius: isCompact ? SSRadius.md : SSRadius.xl)
                        .stroke(Color.ssGlassBorder, lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var foregroundColor: Color {
        switch style {
        case .coral, .navy: .white
        case .outline: .ssCoral
        case .ghost: .ssTextSecondary
        case .glass: .white
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .coral: LinearGradient.ssCoralGradient
        case .navy: LinearGradient.ssNavyGradient
        case .outline, .ghost: Color.clear
        case .glass: Color.ssGlass
        }
    }
}

// MARK: - Chip

struct SSChip: View {
    let label: String
    var icon: String? = nil
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: SSSpacing.xs) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
            }
            Text(label)
                .font(.ssChip)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .foregroundStyle(isSelected ? .white : Color.ssNavy)
        .background(isSelected ? Color.ssCoral : Color.ssSurface)
        .clipShape(Capsule())
        .overlay {
            if !isSelected {
                Capsule().stroke(Color.ssNavy.opacity(0.12), lineWidth: 1)
            }
        }
    }
}

// MARK: - Card

struct SSCard<Content: View>: View {
    var padding: CGFloat = SSSpacing.cardPadding
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(Color.ssCard)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
            .shadow(color: SSShadow.card, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Glass Card (for dark backgrounds)

struct SSGlassCard<Content: View>: View {
    var padding: CGFloat = SSSpacing.cardPadding
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(Color.ssGlassLight)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
            .overlay {
                RoundedRectangle(cornerRadius: SSRadius.xl)
                    .stroke(Color.ssGlassBorder, lineWidth: 1)
            }
    }
}

// MARK: - Progress Indicator (segmented bar)

struct SSProgressBar: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= current ? Color.ssCoral : Color.white.opacity(0.15))
                    .frame(height: 3)
                    .animation(.spring(response: 0.35), value: current)
            }
        }
    }
}

// MARK: - Badge

struct SSBadge: View {
    let text: String
    var color: Color = .ssSea

    var body: some View {
        Text(text)
            .font(.ssCaption)
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Time Display

struct SSTimeDisplay: View {
    let label: String
    let time: String
    var sublabel: String? = nil

    var body: some View {
        VStack(spacing: SSSpacing.xs) {
            Text(label)
                .font(.ssCaption)
                .foregroundStyle(Color.ssTextMuted)
                .textCase(.uppercase)
            Text(time)
                .font(.ssCountdownMedium)
                .foregroundStyle(Color.ssTextOnDark)
            if let sublabel {
                Text(sublabel)
                    .font(.ssCaptionSmall)
                    .foregroundStyle(Color.ssTextMuted)
            }
        }
    }
}

// MARK: - Onboarding Page Container

struct SSOnboardingPage<Content: View>: View {
    let step: Int
    let totalSteps: Int
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            SSProgressBar(total: totalSteps, current: step)
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.top, SSSpacing.md)
                .padding(.bottom, SSSpacing.lg)

            content()

            Spacer(minLength: 0)
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.ssOnboardingBG)
    }
}

// MARK: - Onboarding Navigation Bar

struct SSOnboardingNav: View {
    let backLabel: String
    let nextLabel: String
    var nextIcon: String? = "arrow.right"
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: SSSpacing.md) {
            Button(action: onBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                    Text(backLabel)
                        .font(.ssBodyMedium)
                }
                .foregroundStyle(Color.white.opacity(0.5))
            }
            .buttonStyle(.plain)

            Spacer()

            SSButton(title: nextLabel, icon: nextIcon, isCompact: true) {
                onNext()
            }
            .frame(maxWidth: 200)
        }
        .padding(.bottom, SSSpacing.xxl)
    }
}

// MARK: - Progress Dots (legacy compat)

struct SSProgressDots: View {
    let total: Int
    let current: Int

    var body: some View {
        SSProgressBar(total: total, current: current)
    }
}
