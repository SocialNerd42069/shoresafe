import SwiftUI

// MARK: - Primary Button

struct SSButton: View {
    let title: String
    var style: Style = .coral
    var icon: String? = nil
    let action: () -> Void

    enum Style {
        case coral, navy, outline, ghost
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: SSSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.ssBodyMedium)
                }
                Text(title)
                    .font(.ssSubheadline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, SSSpacing.lg)
            .foregroundStyle(foregroundColor)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
            .overlay {
                if style == .outline {
                    RoundedRectangle(cornerRadius: SSRadius.lg)
                        .stroke(Color.ssCoral, lineWidth: 1.5)
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
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .coral: LinearGradient.ssCoralGradient
        case .navy: LinearGradient.ssNavyGradient
        case .outline, .ghost: Color.clear
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
                    .font(.ssCaptionSmall)
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
                Capsule().stroke(Color.ssNavy.opacity(0.15), lineWidth: 1)
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
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
            .shadow(color: SSShadow.card, radius: 8, x: 0, y: 2)
    }
}

// MARK: - Progress Dots

struct SSProgressDots: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: SSSpacing.sm) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.ssCoral : Color.white.opacity(0.3))
                    .frame(width: index == current ? 24 : 8, height: 8)
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
            .padding(.vertical, 4)
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
            SSProgressDots(total: totalSteps, current: step)
                .padding(.top, SSSpacing.md)
                .padding(.bottom, SSSpacing.xl)

            content()

            Spacer()
        }
        .padding(.horizontal, SSSpacing.screenHorizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.ssOnboardingBG)
    }
}
