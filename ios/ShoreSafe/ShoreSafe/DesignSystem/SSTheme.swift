import SwiftUI

// MARK: - Theme Definition

enum SSThemeID: String, CaseIterable {
    case sunset   // Sunset Deck — warm resort
    case utility  // Cruise Control — Apple-native utility
    case nautical // Nautical Modern — yacht club
    case poster   // Carnival Poster — bright travel poster dopamine
    case beach    // Beach Club — aqua/sea-glass airy resort
    case disney   // Disney Cruise Clean — friendly bold boomer-proof
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

    // Hero background image (optional)
    var heroImageName: String? = nil

    // Hook-specific overrides
    var hookHeroIcon: String = "ferry.fill"
    var hookHeroIconSize: CGFloat = 52
    var hookTitleText: String = "Never miss\nthe ship."
    var hookSubtitleText: String = "Set up your cruise in 60 seconds.\nPierRunner tracks every port day so you\nalways make it back on time."
    var hookCTAText: String = "Set up my cruise"
    var hookUsesImageBackground: Bool = false
    var hookOverlayOpacity: Double = 0.0

    // Timer-specific overrides
    var timerUsesImageBackground: Bool = false
    var timerOverlayOpacity: Double = 0.0
    var timerBadgeStyle: BadgeStyle = .capsule

    enum BadgeStyle {
        case capsule    // standard pill
        case rounded    // rounded rect
        case tag        // tag shape
    }
}

// MARK: - Theme Factory

extension SSThemeTokens {

    static func tokens(for theme: SSThemeID) -> SSThemeTokens {
        switch theme {
        case .sunset:   return sunsetDeck
        case .utility:  return cruiseControl
        case .nautical: return nauticalModern
        case .poster:   return carnivalPoster
        case .beach:    return beachClub
        case .disney:   return disneyCruiseClean
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

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: A) Carnival Poster — bright travel poster vacation dopamine
    // Hot magenta + sunshine yellow + electric blue on a warm cream.
    // Feels like a retro cruise ship poster you'd pin on your wall.
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    private static let carnivalPoster = SSThemeTokens(
        hookBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.45, blue: 0.20),   // hot orange
                    Color(red: 1.0, green: 0.28, blue: 0.40),   // magenta-ish
                    Color(red: 0.85, green: 0.18, blue: 0.52)   // deep magenta
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.05, blue: 0.28),  // deep indigo
                    Color(red: 0.18, green: 0.08, blue: 0.38),
                    Color(red: 0.10, green: 0.04, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerUrgentBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.50, blue: 0.10), Color(red: 1.0, green: 0.25, blue: 0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerCriticalBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.90, green: 0.15, blue: 0.20), Color(red: 0.72, green: 0.08, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        hookTitleColor: .white,
        hookBodyColor: .white.opacity(0.85),
        timerTextPrimary: .white,
        timerTextSecondary: .white.opacity(0.70),
        timerTextMuted: .white.opacity(0.40),
        accent: Color(red: 1.0, green: 0.84, blue: 0.0),                  // sunshine yellow
        accentGradient: LinearGradient(
            colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.68, blue: 0.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        accentSecondary: Color(red: 0.20, green: 0.85, blue: 1.0),        // electric cyan
        badgeColor: Color(red: 1.0, green: 0.84, blue: 0.0),
        badgeUrgentColor: Color(red: 1.0, green: 0.32, blue: 0.30),
        glassBackground: Color.white.opacity(0.15),
        glassBorder: Color.white.opacity(0.25),
        progressFill: Color(red: 1.0, green: 0.84, blue: 0.0),
        progressTrack: Color.white.opacity(0.25),
        buttonBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.70, blue: 0.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        buttonForeground: Color(red: 0.15, green: 0.05, blue: 0.30),      // dark purple text on yellow
        heroGlowColors: [Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.40), Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.0)],
        heroCircleFill: Color.white.opacity(0.18),
        heroCircleBorder: LinearGradient(
            colors: [Color.white.opacity(0.4), Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        heroIconGradient: LinearGradient(
            colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color.white],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        buttonRadius: SSRadius.pill,
        colorScheme: .dark,
        displayDesign: .rounded,
        countdownDesign: .rounded,
        heroImageName: "sunset-deck-hero",
        hookHeroIcon: "sailboat.fill",
        hookHeroIconSize: 56,
        hookTitleText: "Your ship.\nYour schedule.",
        hookSubtitleText: "One tap to know exactly when\nto head back. Never stress about\nmissing the boat again.",
        hookCTAText: "Let's go!",
        hookUsesImageBackground: true,
        hookOverlayOpacity: 0.55,
        timerUsesImageBackground: false,
        timerOverlayOpacity: 0.0,
        timerBadgeStyle: .rounded
    )

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: B) Beach Club — aqua/sea-glass airy resort
    // Think Tulum beach club. Soft aqua + sandy white + coral pink.
    // Light, breezy, Instagram-ready.
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    private static let beachClub = SSThemeTokens(
        hookBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.97, blue: 0.98),  // pale aqua
                    Color(red: 0.95, green: 0.99, blue: 0.99),  // nearly white
                    Color(red: 0.98, green: 0.96, blue: 0.92)   // warm sand
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        timerBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.25, blue: 0.35),  // deep ocean teal
                    Color(red: 0.02, green: 0.18, blue: 0.30),
                    Color(red: 0.06, green: 0.28, blue: 0.38)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerUrgentBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.55, blue: 0.45), Color(red: 1.0, green: 0.40, blue: 0.50)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerCriticalBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.88, green: 0.20, blue: 0.22), Color(red: 0.72, green: 0.12, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        hookTitleColor: Color(red: 0.08, green: 0.22, blue: 0.30),        // deep teal ink
        hookBodyColor: Color(red: 0.30, green: 0.44, blue: 0.50),         // muted teal
        timerTextPrimary: .white,
        timerTextSecondary: .white.opacity(0.70),
        timerTextMuted: .white.opacity(0.40),
        accent: Color(red: 0.0, green: 0.75, blue: 0.72),                 // sea glass teal
        accentGradient: LinearGradient(
            colors: [Color(red: 0.0, green: 0.75, blue: 0.72), Color(red: 0.20, green: 0.88, blue: 0.82)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        accentSecondary: Color(red: 1.0, green: 0.52, blue: 0.55),        // coral pink
        badgeColor: Color(red: 0.0, green: 0.75, blue: 0.72),
        badgeUrgentColor: Color(red: 1.0, green: 0.52, blue: 0.55),
        glassBackground: Color.white.opacity(0.55),
        glassBorder: Color(red: 0.0, green: 0.75, blue: 0.72).opacity(0.20),
        progressFill: Color(red: 0.0, green: 0.75, blue: 0.72),
        progressTrack: Color(red: 0.08, green: 0.22, blue: 0.30).opacity(0.10),
        buttonBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.0, green: 0.75, blue: 0.72), Color(red: 0.10, green: 0.82, blue: 0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        buttonForeground: .white,
        heroGlowColors: [Color(red: 0.0, green: 0.75, blue: 0.72).opacity(0.25), Color(red: 0.0, green: 0.75, blue: 0.72).opacity(0.0)],
        heroCircleFill: Color(red: 0.0, green: 0.75, blue: 0.72).opacity(0.08),
        heroCircleBorder: LinearGradient(
            colors: [Color(red: 0.0, green: 0.75, blue: 0.72).opacity(0.35), Color(red: 1.0, green: 0.52, blue: 0.55).opacity(0.20)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        heroIconGradient: LinearGradient(
            colors: [Color(red: 0.0, green: 0.75, blue: 0.72), Color(red: 0.20, green: 0.88, blue: 0.82)],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        buttonRadius: SSRadius.xxl,
        colorScheme: .light,
        displayDesign: .rounded,
        countdownDesign: .monospaced,
        heroImageName: "cruise-control-hero",
        hookHeroIcon: "beach.umbrella.fill",
        hookHeroIconSize: 48,
        hookTitleText: "Cruise mode:\nactivated.",
        hookSubtitleText: "We'll handle the timing.\nYou just enjoy the beach, the tacos,\nand that third pi\u{00F1}a colada.",
        hookCTAText: "Set up my trip",
        hookUsesImageBackground: true,
        hookOverlayOpacity: 0.35,
        timerUsesImageBackground: false,
        timerOverlayOpacity: 0.0,
        timerBadgeStyle: .capsule
    )

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: C) Disney Cruise Clean — friendly bold high-contrast boomer-proof
    // Deep navy + bright white + royal blue accent. Large text, simple shapes,
    // maximum readability. Feels like a cruise ship info screen.
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    private static let disneyCruiseClean = SSThemeTokens(
        hookBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.08, blue: 0.22),  // deep midnight navy
                    Color(red: 0.06, green: 0.12, blue: 0.32),  // royal navy
                    Color(red: 0.04, green: 0.08, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        ),
        timerBackground: AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.08, blue: 0.22),
                    Color(red: 0.06, green: 0.14, blue: 0.36),
                    Color(red: 0.04, green: 0.10, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerUrgentBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.60, blue: 0.0), Color(red: 1.0, green: 0.42, blue: 0.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        timerCriticalBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.92, green: 0.15, blue: 0.15), Color(red: 0.75, green: 0.10, blue: 0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        hookTitleColor: .white,
        hookBodyColor: .white.opacity(0.80),
        timerTextPrimary: .white,
        timerTextSecondary: .white.opacity(0.75),
        timerTextMuted: .white.opacity(0.45),
        accent: Color(red: 0.22, green: 0.55, blue: 1.0),                 // royal blue
        accentGradient: LinearGradient(
            colors: [Color(red: 0.22, green: 0.55, blue: 1.0), Color(red: 0.35, green: 0.65, blue: 1.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        accentSecondary: Color(red: 1.0, green: 0.78, blue: 0.0),         // gold
        badgeColor: Color(red: 0.22, green: 0.55, blue: 1.0),
        badgeUrgentColor: Color(red: 1.0, green: 0.45, blue: 0.0),
        glassBackground: Color.white.opacity(0.12),
        glassBorder: Color.white.opacity(0.20),
        progressFill: Color(red: 0.22, green: 0.55, blue: 1.0),
        progressTrack: Color.white.opacity(0.18),
        buttonBackground: AnyShapeStyle(
            LinearGradient(
                colors: [Color(red: 0.22, green: 0.55, blue: 1.0), Color(red: 0.30, green: 0.62, blue: 1.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        buttonForeground: .white,
        heroGlowColors: [Color(red: 0.22, green: 0.55, blue: 1.0).opacity(0.30), Color(red: 0.22, green: 0.55, blue: 1.0).opacity(0.0)],
        heroCircleFill: Color.white.opacity(0.14),
        heroCircleBorder: LinearGradient(
            colors: [Color.white.opacity(0.35), Color(red: 1.0, green: 0.78, blue: 0.0).opacity(0.30)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        heroIconGradient: LinearGradient(
            colors: [Color.white, Color(red: 1.0, green: 0.78, blue: 0.0)],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ),
        buttonRadius: SSRadius.lg,
        colorScheme: .dark,
        displayDesign: .rounded,
        countdownDesign: .rounded,
        heroImageName: "nautical-modern-hero",
        hookHeroIcon: "star.fill",
        hookHeroIconSize: 50,
        hookTitleText: "Don't miss\nthe boat!",
        hookSubtitleText: "Big countdown. Loud alerts.\nSimple setup. PierRunner makes sure\nyou're never the one left on the dock.",
        hookCTAText: "Get started",
        hookUsesImageBackground: true,
        hookOverlayOpacity: 0.60,
        timerUsesImageBackground: false,
        timerOverlayOpacity: 0.0,
        timerBadgeStyle: .rounded
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
