import SwiftUI

enum AppBackgroundPreset: String, CaseIterable, Codable, Identifiable {
    case paper
    case rose
    case mint
    case sky
    case peach

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var backgroundColor: Color {
        switch self {
        case .paper:
            return Color(red: 0.98, green: 0.95, blue: 0.93)
        case .rose:
            return Color(red: 0.98, green: 0.91, blue: 0.92)
        case .mint:
            return Color(red: 0.90, green: 0.97, blue: 0.93)
        case .sky:
            return Color(red: 0.90, green: 0.95, blue: 0.99)
        case .peach:
            return Color(red: 0.99, green: 0.92, blue: 0.86)
        }
    }

    var secondaryBackgroundColor: Color {
        switch self {
        case .paper:
            return Color(red: 0.99, green: 0.98, blue: 0.96)
        case .rose:
            return Color(red: 0.99, green: 0.95, blue: 0.96)
        case .mint:
            return Color(red: 0.96, green: 0.99, blue: 0.97)
        case .sky:
            return Color(red: 0.96, green: 0.98, blue: 1.0)
        case .peach:
            return Color(red: 1.0, green: 0.97, blue: 0.94)
        }
    }
}

