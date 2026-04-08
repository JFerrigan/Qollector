import SwiftUI
import UIKit

enum AppFontPreset: String, CaseIterable, Codable, Identifiable {
    case system
    case rounded
    case serif
    case mono
    case condensed
    case avenir
    case avenirNext
    case baskerville
    case chalkboard
    case didot
    case futura
    case georgia
    case gillSans
    case notable
    case optima
    case palatino
    case americanTypewriter
    case copperplate
    case markerFelt

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system:
            return "System"
        case .rounded:
            return "Rounded"
        case .serif:
            return "Serif"
        case .mono:
            return "Mono"
        case .condensed:
            return "Condensed"
        case .avenir:
            return "Avenir"
        case .avenirNext:
            return "Avenir Next"
        case .baskerville:
            return "Baskerville"
        case .chalkboard:
            return "Chalkboard"
        case .didot:
            return "Didot"
        case .futura:
            return "Futura"
        case .georgia:
            return "Georgia"
        case .gillSans:
            return "Gill Sans"
        case .notable:
            return "Noteworthy"
        case .optima:
            return "Optima"
        case .palatino:
            return "Palatino"
        case .americanTypewriter:
            return "Typewriter"
        case .copperplate:
            return "Copperplate"
        case .markerFelt:
            return "Marker Felt"
        }
    }

    func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let adjustedSize = self == .condensed ? size * 0.94 : size
        if let customName = customFontName(for: weight),
           UIFont(name: customName, size: adjustedSize) != nil {
            return .custom(customName, size: adjustedSize)
        }

        return fallbackFont(size: adjustedSize, weight: weight)
    }

    func textStyle(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        switch style {
        case .largeTitle:
            return font(size: 34, weight: weight)
        case .title:
            return font(size: 28, weight: weight)
        case .title2:
            return font(size: 22, weight: weight)
        case .title3:
            return font(size: 20, weight: weight)
        case .headline:
            return font(size: 17, weight: weight)
        case .subheadline:
            return font(size: 15, weight: weight)
        case .caption:
            return font(size: 12, weight: weight)
        default:
            return font(size: 17, weight: weight)
        }
    }

    private func fallbackFont(size: CGFloat, weight: Font.Weight) -> Font {
        switch self {
        case .rounded:
            return .system(size: size, weight: weight, design: .rounded)
        case .serif:
            return .system(size: size, weight: weight, design: .serif)
        case .mono:
            return .system(size: size, weight: weight, design: .monospaced)
        default:
            return .system(size: size, weight: weight, design: .default)
        }
    }

    private func customFontName(for weight: Font.Weight) -> String? {
        switch self {
        case .system, .rounded, .serif, .mono:
            return nil
        case .condensed:
            if weightRank(weight) >= weightRank(.bold) { return "HelveticaNeue-CondensedBold" }
            return "HelveticaNeue-CondensedBlack"
        case .avenir:
            return weightedName(
                weight,
                regular: "Avenir-Book",
                semibold: "Avenir-Medium",
                bold: "Avenir-Heavy"
            )
        case .avenirNext:
            return weightedName(
                weight,
                regular: "AvenirNext-Regular",
                semibold: "AvenirNext-DemiBold",
                bold: "AvenirNext-Bold"
            )
        case .baskerville:
            return weightedName(
                weight,
                regular: "Baskerville",
                semibold: "Baskerville-SemiBold",
                bold: "Baskerville-Bold"
            )
        case .chalkboard:
            return weightedName(
                weight,
                regular: "ChalkboardSE-Regular",
                semibold: "ChalkboardSE-Bold",
                bold: "ChalkboardSE-Bold"
            )
        case .didot:
            return weightedName(
                weight,
                regular: "Didot",
                semibold: "Didot-Bold",
                bold: "Didot-Bold"
            )
        case .futura:
            return weightedName(
                weight,
                regular: "Futura-Medium",
                semibold: "Futura-Bold",
                bold: "Futura-Bold"
            )
        case .georgia:
            return weightedName(
                weight,
                regular: "Georgia",
                semibold: "Georgia-Bold",
                bold: "Georgia-Bold"
            )
        case .gillSans:
            return weightedName(
                weight,
                regular: "GillSans",
                semibold: "GillSans-SemiBold",
                bold: "GillSans-Bold"
            )
        case .notable:
            return weightedName(
                weight,
                regular: "Noteworthy-Light",
                semibold: "Noteworthy-Bold",
                bold: "Noteworthy-Bold"
            )
        case .optima:
            return weightedName(
                weight,
                regular: "Optima-Regular",
                semibold: "Optima-Bold",
                bold: "Optima-Bold"
            )
        case .palatino:
            return weightedName(
                weight,
                regular: "Palatino-Roman",
                semibold: "Palatino-Bold",
                bold: "Palatino-Bold"
            )
        case .americanTypewriter:
            return weightedName(
                weight,
                regular: "AmericanTypewriter",
                semibold: "AmericanTypewriter-Semibold",
                bold: "AmericanTypewriter-Bold"
            )
        case .copperplate:
            return weightedName(
                weight,
                regular: "Copperplate",
                semibold: "Copperplate-Bold",
                bold: "Copperplate-Bold"
            )
        case .markerFelt:
            return weightedName(
                weight,
                regular: "MarkerFelt-Thin",
                semibold: "MarkerFelt-Wide",
                bold: "MarkerFelt-Wide"
            )
        }
    }

    private func weightedName(_ weight: Font.Weight, regular: String, semibold: String, bold: String) -> String {
        if weightRank(weight) >= weightRank(.bold) {
            return bold
        }

        if weightRank(weight) >= weightRank(.semibold) {
            return semibold
        }

        return regular
    }

    private func weightRank(_ weight: Font.Weight) -> Int {
        switch weight {
        case .ultraLight:
            return 100
        case .thin:
            return 200
        case .light:
            return 300
        case .regular:
            return 400
        case .medium:
            return 500
        case .semibold:
            return 600
        case .bold:
            return 700
        case .heavy:
            return 800
        case .black:
            return 900
        default:
            return 400
        }
    }
}
