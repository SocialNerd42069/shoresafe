import SwiftUI

// MARK: - ShoreSafe Spacing & Layout Tokens

enum SSSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48

    static let cardPadding: CGFloat = 20
    static let screenHorizontal: CGFloat = 24
    static let screenVertical: CGFloat = 16
}

enum SSRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let pill: CGFloat = 100
}

enum SSShadow {
    static let card = Color.black.opacity(0.06)
    static let elevated = Color.black.opacity(0.12)
}
