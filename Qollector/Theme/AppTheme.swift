import SwiftUI
import UIKit

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
    static func palette(background: AppColorPreset, ui: AppColorPreset) -> AppThemePalette {
        let backgroundColor = background.uiColor
        let uiColor = ui.uiColor
        let elevatedSurface = uiColor.mixed(with: backgroundColor, amount: 0.28).lightened(by: 0.34)
        let deeperSurface = uiColor.mixed(with: backgroundColor, amount: 0.18).lightened(by: 0.22)
        let lineColor = uiColor.mixed(with: backgroundColor, amount: 0.68).darkened(by: 0.08)
        let primaryTextBase = backgroundColor.isLight ? UIColor.black : UIColor.white
        let secondaryTextBase = backgroundColor.isLight ? UIColor.black : UIColor.white
        let accentBase = uiColor.darkened(by: uiColor.isLight ? 0.22 : -0.08)

        return AppThemePalette(
            background: Color(uiColor: backgroundColor.lightened(by: backgroundColor.isLight ? 0.02 : 0.06)),
            secondaryBackground: Color(uiColor: backgroundColor.mixed(with: uiColor, amount: 0.08).lightened(by: backgroundColor.isLight ? 0.07 : 0.12)),
            surfaceRose: Color(uiColor: uiColor.mixed(with: backgroundColor, amount: 0.18).lightened(by: 0.36)),
            surfaceMint: Color(uiColor: elevatedSurface),
            surfaceSky: Color(uiColor: uiColor.mixed(with: backgroundColor, amount: 0.32).lightened(by: 0.30)),
            surfaceButter: Color(uiColor: deeperSurface),
            line: Color(uiColor: lineColor),
            textPrimary: Color(uiColor: primaryTextBase.withAlphaComponent(backgroundColor.isLight ? 0.86 : 0.92)),
            textSecondary: Color(uiColor: secondaryTextBase.withAlphaComponent(backgroundColor.isLight ? 0.58 : 0.72)),
            accentFill: Color(uiColor: accentBase),
            accentContent: Color(uiColor: accentBase.accessibleForeground)
        )
    }

    static let outerPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 18
    static let cardRadius: CGFloat = 28
    static let innerRadius: CGFloat = 18
}

private extension UIColor {
    var rgba: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    var isLight: Bool {
        let (red, green, blue, _) = rgba
        let luminance = (0.299 * red) + (0.587 * green) + (0.114 * blue)
        return luminance > 0.62
    }

    var accessibleForeground: UIColor {
        isLight ? .black : .white
    }

    func mixed(with other: UIColor, amount: CGFloat) -> UIColor {
        let clamped = min(max(amount, 0), 1)
        let (red1, green1, blue1, alpha1) = rgba
        let (red2, green2, blue2, alpha2) = other.rgba
        return UIColor(
            red: (red1 * (1 - clamped)) + (red2 * clamped),
            green: (green1 * (1 - clamped)) + (green2 * clamped),
            blue: (blue1 * (1 - clamped)) + (blue2 * clamped),
            alpha: (alpha1 * (1 - clamped)) + (alpha2 * clamped)
        )
    }

    func lightened(by amount: CGFloat) -> UIColor {
        mixed(with: .white, amount: amount)
    }

    func darkened(by amount: CGFloat) -> UIColor {
        if amount < 0 {
            return lightened(by: abs(amount))
        }

        return mixed(with: .black, amount: amount)
    }
}

private struct AppThemePaletteKey: EnvironmentKey {
    static let defaultValue = AppTheme.palette(background: .paper, ui: .rose)
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

struct AppFontModifier: ViewModifier {
    let preset: AppFontPreset

    func body(content: Content) -> some View {
        content.font(preset.textStyle(.body))
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
    func appFont(_ preset: AppFontPreset) -> some View {
        modifier(AppFontModifier(preset: preset))
    }

    func cardSurface(_ fill: Color) -> some View {
        modifier(CardSurface(fill: fill))
    }
}
