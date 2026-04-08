import SwiftUI

enum AppFontPreset: String, CaseIterable, Codable, Identifiable {
    case system
    case rounded
    case serif
    case mono
    case condensed

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
        }
    }

    func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch self {
        case .system:
            return .system(size: size, weight: weight, design: .default)
        case .rounded:
            return .system(size: size, weight: weight, design: .rounded)
        case .serif:
            return .system(size: size, weight: weight, design: .serif)
        case .mono:
            return .system(size: size, weight: weight, design: .monospaced)
        case .condensed:
            return .system(size: size * 0.94, weight: weight, design: .default)
        }
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
}
