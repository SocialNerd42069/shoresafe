import SwiftUI

// MARK: - ShoreSafe Typography
// System fonts with premium weight tuning. Tighter tracking on display, roomier on body.

extension Font {
    // MARK: Display — big hero text
    static let ssDisplayLarge = Font.system(size: 36, weight: .bold, design: .rounded)
    static let ssDisplayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    static let ssDisplaySmall = Font.system(size: 24, weight: .bold, design: .rounded)

    // MARK: Headlines
    static let ssHeadline = Font.system(size: 22, weight: .semibold, design: .default)
    static let ssSubheadline = Font.system(size: 17, weight: .semibold, design: .default)

    // MARK: Body
    static let ssBody = Font.system(size: 16, weight: .regular, design: .default)
    static let ssBodyMedium = Font.system(size: 16, weight: .medium, design: .default)
    static let ssBodySmall = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: Captions
    static let ssCaption = Font.system(size: 12, weight: .semibold, design: .default)
    static let ssCaptionSmall = Font.system(size: 11, weight: .medium, design: .default)

    // MARK: Countdown (monospaced for timers)
    static let ssCountdownLarge = Font.system(size: 60, weight: .heavy, design: .monospaced)
    static let ssCountdownMedium = Font.system(size: 40, weight: .bold, design: .monospaced)
    static let ssCountdownSmall = Font.system(size: 24, weight: .semibold, design: .monospaced)

    // MARK: Chip / Tag
    static let ssChip = Font.system(size: 14, weight: .semibold, design: .rounded)

    // MARK: Overline — small labels
    static let ssOverline = Font.system(size: 11, weight: .bold, design: .default)
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
        modifier(SSTextStyle(font: .ssDisplayLarge, color: .ssTextOnDark, tracking: -0.5))
    }

    func ssOnboardingBody() -> some View {
        modifier(SSTextStyle(font: .ssBody, color: .ssTextOnDark.opacity(0.7), tracking: 0.1))
    }

    func ssOverlineStyle() -> some View {
        modifier(SSTextStyle(font: .ssOverline, color: .ssTextMuted, tracking: 1.5))
            .textCase(.uppercase)
    }
}
