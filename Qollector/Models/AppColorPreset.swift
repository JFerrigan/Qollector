import SwiftUI
import UIKit

enum AppColorPreset: String, CaseIterable, Codable, Identifiable {
    case paper
    case sand
    case peach
    case coral
    case rose
    case cherry
    case terracotta
    case butter
    case gold
    case olive
    case mint
    case sage
    case emerald
    case aqua
    case sky
    case cobalt
    case navy
    case lavender
    case lilac
    case plum
    case slate

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        switch self {
        case .paper:
            return (0.97, 0.94, 0.90)
        case .sand:
            return (0.88, 0.82, 0.72)
        case .peach:
            return (0.97, 0.78, 0.66)
        case .coral:
            return (0.93, 0.58, 0.52)
        case .rose:
            return (0.89, 0.54, 0.63)
        case .cherry:
            return (0.71, 0.24, 0.33)
        case .terracotta:
            return (0.73, 0.42, 0.29)
        case .butter:
            return (0.96, 0.88, 0.53)
        case .gold:
            return (0.83, 0.66, 0.22)
        case .olive:
            return (0.48, 0.53, 0.28)
        case .mint:
            return (0.58, 0.84, 0.72)
        case .sage:
            return (0.56, 0.67, 0.57)
        case .emerald:
            return (0.17, 0.57, 0.44)
        case .aqua:
            return (0.34, 0.78, 0.78)
        case .sky:
            return (0.49, 0.72, 0.92)
        case .cobalt:
            return (0.27, 0.43, 0.82)
        case .navy:
            return (0.16, 0.24, 0.40)
        case .lavender:
            return (0.73, 0.67, 0.90)
        case .lilac:
            return (0.83, 0.70, 0.91)
        case .plum:
            return (0.43, 0.28, 0.47)
        case .slate:
            return (0.45, 0.50, 0.58)
        }
    }

    var color: Color {
        Color(red: components.red, green: components.green, blue: components.blue)
    }

    var uiColor: UIColor {
        UIColor(red: components.red, green: components.green, blue: components.blue, alpha: 1)
    }
}
