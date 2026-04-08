import SwiftUI

enum VinylColorToken: String, Codable, CaseIterable, Identifiable {
    case peach
    case coral
    case butter
    case mint
    case sky
    case lilac
    case navy
    case cream

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var color: Color {
        switch self {
        case .peach:
            return Color(red: 0.98, green: 0.82, blue: 0.73)
        case .coral:
            return Color(red: 0.94, green: 0.67, blue: 0.66)
        case .butter:
            return Color(red: 0.98, green: 0.92, blue: 0.67)
        case .mint:
            return Color(red: 0.74, green: 0.90, blue: 0.83)
        case .sky:
            return Color(red: 0.73, green: 0.84, blue: 0.96)
        case .lilac:
            return Color(red: 0.82, green: 0.78, blue: 0.95)
        case .navy:
            return Color(red: 0.22, green: 0.28, blue: 0.42)
        case .cream:
            return Color(red: 0.99, green: 0.97, blue: 0.93)
        }
    }
}
