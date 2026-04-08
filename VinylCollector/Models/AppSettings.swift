import Foundation
import SwiftData

@Model
final class AppSettings {
    var preferredRatingStyleRawValue: String
    var didSeedSampleLibrary: Bool

    init(preferredRatingStyle: RatingStyle = .stars, didSeedSampleLibrary: Bool = false) {
        self.preferredRatingStyleRawValue = preferredRatingStyle.rawValue
        self.didSeedSampleLibrary = didSeedSampleLibrary
    }

    var preferredRatingStyle: RatingStyle {
        get { RatingStyle(rawValue: preferredRatingStyleRawValue) ?? .stars }
        set { preferredRatingStyleRawValue = newValue.rawValue }
    }
}

