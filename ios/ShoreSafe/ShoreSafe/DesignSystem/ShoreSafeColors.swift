import SwiftUI

// MARK: - ShoreSafe Color Palette
// Deep ocean + warm coral. Premium, confident, modern cruise.

extension Color {
    // MARK: Primary
    static let ssNavy = Color(red: 0.06, green: 0.09, blue: 0.19)          // #0F1730
    static let ssNavyLight = Color(red: 0.10, green: 0.15, blue: 0.29)     // #1A264A
    static let ssNavyMid = Color(red: 0.08, green: 0.12, blue: 0.24)       // #141F3D
    static let ssCoral = Color(red: 1.0, green: 0.36, blue: 0.30)          // #FF5C4D
    static let ssCoralLight = Color(red: 1.0, green: 0.50, blue: 0.40)     // #FF8066
    static let ssCoralSoft = Color(red: 1.0, green: 0.36, blue: 0.30, opacity: 0.12)

    // MARK: Surfaces
    static let ssSurface = Color(red: 0.965, green: 0.973, blue: 0.984)    // #F7F8FB
    static let ssCard = Color.white
    static let ssSurfaceDark = Color(red: 0.07, green: 0.11, blue: 0.22)   // #121C38
    static let ssGlass = Color.white.opacity(0.08)
    static let ssGlassLight = Color.white.opacity(0.12)
    static let ssGlassBorder = Color.white.opacity(0.15)

    // MARK: Accents
    static let ssSunrise = Color(red: 1.0, green: 0.76, blue: 0.30)        // #FFC24D
    static let ssSea = Color(red: 0.12, green: 0.72, blue: 0.76)           // #1FB8C2
    static let ssSeaLight = Color(red: 0.20, green: 0.82, blue: 0.85)      // #33D1D9
    static let ssSuccess = Color(red: 0.18, green: 0.80, blue: 0.52)       // #2ECC85
    static let ssAqua = Color(red: 0.30, green: 0.85, blue: 0.90)          // #4DD9E6

    // MARK: Text
    static let ssTextPrimary = Color(red: 0.06, green: 0.09, blue: 0.19)
    static let ssTextSecondary = Color(red: 0.38, green: 0.42, blue: 0.52) // #616B85
    static let ssTextOnDark = Color.white
    static let ssTextMuted = Color(red: 0.55, green: 0.59, blue: 0.68)     // #8C96AD

    // MARK: Semantic
    static let ssWarning = Color(red: 1.0, green: 0.68, blue: 0.12)        // #FFAD1F
    static let ssDanger = Color(red: 0.90, green: 0.22, blue: 0.18)        // #E6382E
}

// MARK: - Gradients
extension LinearGradient {
    static let ssNavyGradient = LinearGradient(
        colors: [Color.ssNavy, Color.ssNavyLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let ssCoralGradient = LinearGradient(
        colors: [Color.ssCoral, Color.ssCoralLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let ssSunriseGradient = LinearGradient(
        colors: [Color.ssCoral, Color.ssSunrise],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )

    static let ssOnboardingBG = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.07, blue: 0.16),
            Color(red: 0.08, green: 0.12, blue: 0.24),
            Color(red: 0.06, green: 0.09, blue: 0.19)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let ssOceanGradient = LinearGradient(
        colors: [
            Color(red: 0.06, green: 0.09, blue: 0.19),
            Color(red: 0.08, green: 0.14, blue: 0.30),
            Color(red: 0.06, green: 0.11, blue: 0.22)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let ssUrgentGradient = LinearGradient(
        colors: [Color.ssWarning.opacity(0.95), Color.ssCoral],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let ssCriticalGradient = LinearGradient(
        colors: [Color.ssDanger, Color(red: 0.75, green: 0.15, blue: 0.12)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
