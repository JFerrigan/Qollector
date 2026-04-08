import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.98, green: 0.95, blue: 0.93)
    static let secondaryBackground = Color(red: 0.99, green: 0.98, blue: 0.96)
    static let surfaceRose = Color(red: 0.99, green: 0.90, blue: 0.90)
    static let surfaceMint = Color(red: 0.88, green: 0.96, blue: 0.92)
    static let surfaceSky = Color(red: 0.89, green: 0.94, blue: 0.99)
    static let surfaceButter = Color(red: 0.99, green: 0.95, blue: 0.82)
    static let line = Color(red: 0.87, green: 0.80, blue: 0.78)
    static let textPrimary = Color(red: 0.17, green: 0.18, blue: 0.22)
    static let textSecondary = Color(red: 0.40, green: 0.41, blue: 0.49)

    static let outerPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 18
    static let cardRadius: CGFloat = 28
    static let innerRadius: CGFloat = 18
}

struct CardSurface: ViewModifier {
    let fill: Color

    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                    .stroke(AppTheme.line.opacity(0.7), lineWidth: 1)
            )
    }
}

extension View {
    func cardSurface(_ fill: Color) -> some View {
        modifier(CardSurface(fill: fill))
    }
}

