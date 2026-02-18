import SwiftUI

// MARK: - Theme Definition

enum SSThemeID: String, CaseIterable {
    case sunset   // Sunset Deck — warm resort
    case utility  // Cruise Control — Apple-native utility
    case nautical // Nautical Modern — yacht club
}

// MARK: - Theme Tokens

struct SSThemeTokens {
    // Backgrounds
    let hookBackground: AnyShapeStyle
    let timerBackground: AnyShapeStyle
    let timerUrgentBackground: AnyShapeStyle
    let timerCriticalBackground: AnyShapeStyle

    // Text
    let hookTitleColor: Color
    let hookBodyColor: Color
    let timerTextPrimary: Color
    let timerTextSecondary: Color
    let timerTextMuted: Color

    // Accent
    let accent: Color
    let accentGradient: LinearGradient
    let accentSecondary: Color

    // Surfaces
    let badgeColor: Color
    let badgeUrgentColor: Color
    let glassBackground: Color
    let glassBorder: Color
    let progressFill: Color
    let progressTrack: Color

    // Button
    let buttonBackground: AnyShapeStyle
    let buttonForeground: Color

    // Hero icon
    let heroGlowColors: [Color]
    let heroCircleFill: Color
    let heroCircleBorder: LinearGradient
    let heroIconGradient: LinearGradient

    // Corner radius
    let buttonRadius: CGFloat

    // Color scheme
    let colorScheme: ColorScheme

    // Typography overrides
    let displayDesign: Font.Design
    let countdownDesign: Font.Design
}

// MARK: - Theme Factory

extension SSThemeTokens {

    static func tokens(for theme: SSThemeID) -> SSThemeTokens {
        switch theme {
        case .sunset:   return sunsetDeck
        case .utility:  return cruiseControl
        case .nautical: return nauticalModern
        }
    }

    // MARK: Sunset Deck — warm resort vibes
    // Navy ink + sand/white + sunset coral accent (orange-leaning)

    private static let sunsetDeck = SSThemeTokens(
        hookBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.90),  // warm sand
                    Color(red: 1.0, green: 0.97, blue: 0.92),
                    Color(red: 0.99, green: 0.93, blue: 0.86)   // warm peach tint
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        timerBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.06, blue: 0.16),
                    Color(red: 0.14, green: 0.08, blue: 0.22),
                    Color(red: 0.10, green: 0.05, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerUrgentBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.55, blue: 0.20), Color(red: 0.95, green: 0.35, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerCriticalBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.85, green: 0.18, blue: 0.12), Color(red: 0.70, green: 0.12, blue: 0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        hookTitleColor: Color(red: 0.10, green: 0.08, blue: 0.18),       // deep navy ink
        hookBodyColor: Color(red: 0.35, green: 0.32, blue: 0.40),
        timerTextPrimary: .white,
        timerTextSecondary: .white.opacity(0.6),
        timerTextMuted: .white.opacity(0.35),
        accent: Color(red: 1.0, green: 0.45, blue: 0.20),                 // sunset orange
        accentGradient: LinearGradient(
            colors: [Color(red: 1.0, green: 0.45, blue: 0.20), Color(red: 1.0, green: 0.60, blue: 0.25)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        accentSecondary: Color(red: 1.0, green: 0.70, blue: 0.28),        // golden
        badgeColor: Color(red: 0.18, green: 0.70, blue: 0.72),
        badgeUrgentColor: Color(red: 1.0, green: 0.68, blue: 0.12),
        glassBackground: Color.white.opacity(0.10),
        glassBorder: Color.white.opacity(0.18),
        progressFill: Color(red: 1.0, green: 0.45, blue: 0.20),
        progressTrack: Color(red: 0.10, green: 0.08, blue: 0.18).opacity(0.12),
        buttonBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.45, blue: 0.20), Color(red: 1.0, green: 0.55, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        buttonForeground: .white,
        heroGlowColors: [Color(red: 1.0, green: 0.55, blue: 0.20).opacity(0.30), Color(red: 1.0, green: 0.55, blue: 0.20).opacity(0.0)],
        heroCircleFill: Color(red: 1.0, green: 0.45, blue: 0.20).opacity(0.10),
        heroCircleBorder: LinearGradient(
            colors: [Color(red: 1.0, green: 0.50, blue: 0.22).opacity(0.5), Color(red: 1.0, green: 0.70, blue: 0.28).opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        heroIconGradient: LinearGradient(
            colors: [Color(red: 1.0, green: 0.45, blue: 0.20), Color(red: 1.0, green: 0.70, blue: 0.28)],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        buttonRadius: SSRadius.xl,
        colorScheme: .light,
        displayDesign: .rounded,
        countdownDesign: .monospaced
    )

    // MARK: Cruise Control — Apple-native utility
    // Very minimal, white/slate, muted coral only for primary actions

    private static let cruiseControl = SSThemeTokens(
        hookBackground: AnyShapeStyle(Color.white),
        timerBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.96, blue: 0.97),
                    Color(red: 0.98, green: 0.98, blue: 0.99)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        timerUrgentBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.92, blue: 0.88), Color(red: 1.0, green: 0.96, blue: 0.94)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerCriticalBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.88, blue: 0.85), Color(red: 1.0, green: 0.92, blue: 0.90)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        hookTitleColor: Color(red: 0.11, green: 0.11, blue: 0.12),        // near-black
        hookBodyColor: Color(red: 0.44, green: 0.44, blue: 0.47),         // slate
        timerTextPrimary: Color(red: 0.11, green: 0.11, blue: 0.12),
        timerTextSecondary: Color(red: 0.44, green: 0.44, blue: 0.47),
        timerTextMuted: Color(red: 0.62, green: 0.62, blue: 0.65),
        accent: Color(red: 0.90, green: 0.38, blue: 0.34),                // muted coral
        accentGradient: LinearGradient(
            colors: [Color(red: 0.90, green: 0.38, blue: 0.34), Color(red: 0.92, green: 0.48, blue: 0.42)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        accentSecondary: Color(red: 0.55, green: 0.55, blue: 0.58),
        badgeColor: Color(red: 0.55, green: 0.55, blue: 0.58),
        badgeUrgentColor: Color(red: 0.90, green: 0.38, blue: 0.34),
        glassBackground: Color(red: 0.94, green: 0.94, blue: 0.96),
        glassBorder: Color(red: 0.88, green: 0.88, blue: 0.90),
        progressFill: Color(red: 0.90, green: 0.38, blue: 0.34),
        progressTrack: Color(red: 0.88, green: 0.88, blue: 0.90),
        buttonBackground: AnyShapeStyle(Color(red: 0.90, green: 0.38, blue: 0.34)),
        buttonForeground: .white,
        heroGlowColors: [Color(red: 0.90, green: 0.38, blue: 0.34).opacity(0.08), Color.clear],
        heroCircleFill: Color(red: 0.96, green: 0.96, blue: 0.97),
        heroCircleBorder: LinearGradient(
            colors: [Color(red: 0.88, green: 0.88, blue: 0.90), Color(red: 0.92, green: 0.92, blue: 0.94)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        heroIconGradient: LinearGradient(
            colors: [Color(red: 0.90, green: 0.38, blue: 0.34), Color(red: 0.92, green: 0.48, blue: 0.42)],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        buttonRadius: SSRadius.md,
        colorScheme: .light,
        displayDesign: .default,
        countdownDesign: .monospaced
    )

    // MARK: Nautical Modern — yacht club
    // Off-white + deep navy + teal secondary; coral for urgency

    private static let nauticalModern = SSThemeTokens(
        hookBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.09, blue: 0.19),
                    Color(red: 0.08, green: 0.12, blue: 0.24),
                    Color(red: 0.06, green: 0.09, blue: 0.19)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        timerBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.09, blue: 0.19),
                    Color(red: 0.08, green: 0.14, blue: 0.30),
                    Color(red: 0.06, green: 0.11, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerUrgentBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.68, blue: 0.12).opacity(0.95), Color(red: 1.0, green: 0.36, blue: 0.30)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerCriticalBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.90, green: 0.22, blue: 0.18), Color(red: 0.75, green: 0.15, blue: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        hookTitleColor: .white,
        hookBodyColor: .white.opacity(0.7),
        timerTextPrimary: .white,
        timerTextSecondary: .white.opacity(0.6),
        timerTextMuted: .white.opacity(0.35),
        accent: Color(red: 0.12, green: 0.72, blue: 0.76),                // teal
        accentGradient: LinearGradient(
            colors: [Color(red: 0.12, green: 0.72, blue: 0.76), Color(red: 0.20, green: 0.82, blue: 0.85)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        accentSecondary: Color(red: 1.0, green: 0.76, blue: 0.30),        // gold
        badgeColor: Color(red: 0.12, green: 0.72, blue: 0.76),
        badgeUrgentColor: Color(red: 1.0, green: 0.36, blue: 0.30),
        glassBackground: Color.white.opacity(0.08),
        glassBorder: Color.white.opacity(0.15),
        progressFill: Color(red: 0.12, green: 0.72, blue: 0.76),
        progressTrack: Color.white.opacity(0.15),
        buttonBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.72, blue: 0.76), Color(red: 0.20, green: 0.82, blue: 0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        buttonForeground: .white,
        heroGlowColors: [Color(red: 0.12, green: 0.72, blue: 0.76).opacity(0.25), Color(red: 0.12, green: 0.72, blue: 0.76).opacity(0.0)],
        heroCircleFill: Color.white.opacity(0.12),
        heroCircleBorder: LinearGradient(
            colors: [Color(red: 0.12, green: 0.72, blue: 0.76).opacity(0.5), Color(red: 1.0, green: 0.76, blue: 0.30).opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        heroIconGradient: LinearGradient(
            colors: [Color(red: 0.12, green: 0.72, blue: 0.76), Color(red: 0.20, green: 0.82, blue: 0.85)],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        buttonRadius: SSRadius.xl,
        colorScheme: .dark,
        displayDesign: .rounded,
        countdownDesign: .monospaced
    )
}

// MARK: - Environment Key

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: SSThemeTokens = .tokens(for: .nautical)
}

extension EnvironmentValues {
    var ssTheme: SSThemeTokens {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

extension View {
    func ssTheme(_ theme: SSThemeID) -> some View {
        environment(\.ssTheme, SSThemeTokens.tokens(for: theme))
    }
}
