import SwiftUI

struct AppThemePalette {
    let background: Color
    let secondaryBackground: Color
    let surfaceRose: Color
    let surfaceMint: Color
    let surfaceSky: Color
    let surfaceButter: Color
    let line: Color
    let textPrimary: Color
    let textSecondary: Color
    let accentFill: Color
    let accentContent: Color
}

enum AppTheme {
    static func palette(for preset: AppBackgroundPreset) -> AppThemePalette {
        AppThemePalette(
            background: preset.backgroundColor,
            secondaryBackground: preset.secondaryBackgroundColor,
            surfaceRose: Color(red: 0.99, green: 0.90, blue: 0.90),
            surfaceMint: Color(red: 0.88, green: 0.96, blue: 0.92),
            surfaceSky: Color(red: 0.89, green: 0.94, blue: 0.99),
            surfaceButter: Color(red: 0.99, green: 0.95, blue: 0.82),
            line: Color(red: 0.87, green: 0.80, blue: 0.78),
            textPrimary: Color(red: 0.17, green: 0.18, blue: 0.22),
            textSecondary: Color(red: 0.40, green: 0.41, blue: 0.49),
            accentFill: Color(red: 0.41, green: 0.34, blue: 0.42),
            accentContent: Color(red: 0.95, green: 0.88, blue: 0.92)
        )
    }

    static let outerPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 18
    static let cardRadius: CGFloat = 28
    static let innerRadius: CGFloat = 18
}

private struct AppThemePaletteKey: EnvironmentKey {
    static let defaultValue = AppTheme.palette(for: .rose)
}

private struct AppFontPresetKey: EnvironmentKey {
    static let defaultValue: AppFontPreset = .rounded
}

extension EnvironmentValues {
    var appThemePalette: AppThemePalette {
        get { self[AppThemePaletteKey.self] }
        set { self[AppThemePaletteKey.self] = newValue }
    }

    var appFontPreset: AppFontPreset {
        get { self[AppFontPresetKey.self] }
        set { self[AppFontPresetKey.self] = newValue }
    }
}

struct CardSurface: ViewModifier {
    @Environment(\.appThemePalette) private var palette
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
                    .stroke(palette.line.opacity(0.7), lineWidth: 1)
            )
    }
}

extension View {
    func cardSurface(_ fill: Color) -> some View {
        modifier(CardSurface(fill: fill))
    }
}
