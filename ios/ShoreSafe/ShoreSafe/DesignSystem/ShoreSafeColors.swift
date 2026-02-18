import SwiftUI

// MARK: - ShoreSafe Color Palette
// Deep navy + sunrise coral. Premium, calm, cruise-modern.

extension Color {
    // MARK: Primary
    static let ssNavy = Color(red: 0.07, green: 0.11, blue: 0.22)          // #121C38
    static let ssNavyLight = Color(red: 0.12, green: 0.18, blue: 0.33)     // #1F2E54
    static let ssCoral = Color(red: 1.0, green: 0.38, blue: 0.32)          // #FF6152
    static let ssCoralLight = Color(red: 1.0, green: 0.55, blue: 0.45)     // #FF8C73

    // MARK: Surfaces
    static let ssSurface = Color(red: 0.96, green: 0.97, blue: 0.98)       // #F5F7FA
    static let ssCard = Color.white
    static let ssSurfaceDark = Color(red: 0.09, green: 0.13, blue: 0.25)   // #172140

    // MARK: Accents
    static let ssSunrise = Color(red: 1.0, green: 0.78, blue: 0.36)        // #FFC75C
    static let ssSea = Color(red: 0.18, green: 0.75, blue: 0.78)           // #2EC0C7
    static let ssSuccess = Color(red: 0.2, green: 0.78, blue: 0.55)        // #33C78C

    // MARK: Text
    static let ssTextPrimary = Color(red: 0.07, green: 0.11, blue: 0.22)
    static let ssTextSecondary = Color(red: 0.4, green: 0.44, blue: 0.53)  // #667087
    static let ssTextOnDark = Color.white
    static let ssTextMuted = Color(red: 0.6, green: 0.63, blue: 0.7)       // #99A1B3

    // MARK: Semantic
    static let ssWarning = Color(red: 1.0, green: 0.65, blue: 0.0)         // #FFA600
    static let ssDanger = Color(red: 0.92, green: 0.26, blue: 0.21)        // #EB4235
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
        startPoint: .leading,
        endPoint: .trailing
    )

    static let ssSunriseGradient = LinearGradient(
        colors: [Color.ssCoral.opacity(0.9), Color.ssSunrise],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )

    static let ssOnboardingBG = LinearGradient(
        colors: [Color.ssNavy, Color(red: 0.05, green: 0.08, blue: 0.18)],
        startPoint: .top,
        endPoint: .bottom
    )
}
