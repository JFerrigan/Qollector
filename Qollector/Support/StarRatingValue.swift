import Foundation

enum StarFillState: Equatable {
    case empty
    case half
    case full

    var symbolName: String {
        switch self {
        case .empty:
            return "star"
        case .half:
            return "star.leadinghalf.filled"
        case .full:
            return "star.fill"
        }
    }
}

enum StarRatingValue {
    static let minValue = 1
    static let maxValue = 10
    static let starCount = 5

    static func clamped(_ ratingValue: Int) -> Int {
        min(max(ratingValue, minValue), maxValue)
    }

    static func fillState(for starIndex: Int, ratingValue: Int) -> StarFillState {
        let clampedValue = clamped(ratingValue)
        let localValue = min(max(clampedValue - ((starIndex - 1) * 2), 0), 2)

        switch localValue {
        case 2:
            return .full
        case 1:
            return .half
        default:
            return .empty
        }
    }

    static func accessibilityLabel(for ratingValue: Int) -> String {
        let clampedValue = clamped(ratingValue)
        let stars = Double(clampedValue) / 2.0
        let fractionLength = clampedValue.isMultiple(of: 2) ? 0 : 1
        return "\(stars.formatted(.number.precision(.fractionLength(fractionLength)))) stars"
    }

    static func tenPointLabel(for ratingValue: Int) -> String {
        "\(clamped(ratingValue))/10"
    }
}
