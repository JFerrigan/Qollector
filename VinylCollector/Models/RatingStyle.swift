import Foundation

enum RatingStyle: String, Codable, CaseIterable, Identifiable {
    case stars
    case tenPoint

    var id: String { rawValue }

    var title: String {
        switch self {
        case .stars:
            return "5 Stars"
        case .tenPoint:
            return "1-10"
        }
    }
}

