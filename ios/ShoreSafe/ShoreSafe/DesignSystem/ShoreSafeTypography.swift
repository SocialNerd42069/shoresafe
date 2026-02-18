import SwiftUI

// MARK: - ShoreSafe Typography
// System fonts, tuned weights. Premium feel via tracking + weight combos.

extension Font {
    // MARK: Display
    static let ssDisplayLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    static let ssDisplayMedium = Font.system(size: 28, weight: .bold, design: .rounded)

    // MARK: Headlines
    static let ssHeadline = Font.system(size: 22, weight: .semibold, design: .default)
    static let ssSubheadline = Font.system(size: 17, weight: .medium, design: .default)

    // MARK: Body
    static let ssBody = Font.system(size: 16, weight: .regular, design: .default)
    static let ssBodyMedium = Font.system(size: 16, weight: .medium, design: .default)
    static let ssBodySmall = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: Captions
    static let ssCaption = Font.system(size: 12, weight: .medium, design: .default)
    static let ssCaptionSmall = Font.system(size: 11, weight: .regular, design: .default)

    // MARK: Countdown (monospaced for timers)
    static let ssCountdownLarge = Font.system(size: 64, weight: .bold, design: .monospaced)
    static let ssCountdownMedium = Font.system(size: 40, weight: .bold, design: .monospaced)
    static let ssCountdownSmall = Font.system(size: 24, weight: .semibold, design: .monospaced)

    // MARK: Chip / Tag
    static let ssChip = Font.system(size: 14, weight: .semibold, design: .rounded)
}

// MARK: - Text Style Modifiers

struct SSTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
    }
}

extension View {
    func ssDisplayStyle() -> some View {
        modifier(SSTextStyle(font: .ssDisplayLarge, color: .ssTextPrimary, tracking: -0.5))
    }

    func ssOnboardingTitle() -> some View {
        modifier(SSTextStyle(font: .ssDisplayMedium, color: .ssTextOnDark, tracking: -0.3))
    }

    func ssOnboardingBody() -> some View {
        modifier(SSTextStyle(font: .ssBody, color: .ssTextOnDark.opacity(0.8), tracking: 0))
    }
}
