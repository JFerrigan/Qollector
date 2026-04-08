import Foundation

enum RecordPatternPreset: String, Codable, CaseIterable, Identifiable {
    case rings
    case split
    case waves
    case orbit
    case checker

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

