import Foundation
import SwiftData

@Model
final class AppSettings {
    var preferredRatingStyleRawValue: String
    var backgroundPresetRawValue: String
    var fontPresetRawValue: String
    var didSeedSampleLibrary: Bool

    init(
        preferredRatingStyle: RatingStyle = .stars,
        backgroundPreset: AppBackgroundPreset = .paper,
        fontPreset: AppFontPreset = .rounded,
        didSeedSampleLibrary: Bool = false
    ) {
        self.preferredRatingStyleRawValue = preferredRatingStyle.rawValue
        self.backgroundPresetRawValue = backgroundPreset.rawValue
        self.fontPresetRawValue = fontPreset.rawValue
        self.didSeedSampleLibrary = didSeedSampleLibrary
    }

    var preferredRatingStyle: RatingStyle {
        get { RatingStyle(rawValue: preferredRatingStyleRawValue) ?? .stars }
        set { preferredRatingStyleRawValue = newValue.rawValue }
    }

    var backgroundPreset: AppBackgroundPreset {
        get { AppBackgroundPreset(rawValue: backgroundPresetRawValue) ?? .paper }
        set { backgroundPresetRawValue = newValue.rawValue }
    }

    var fontPreset: AppFontPreset {
        get { AppFontPreset(rawValue: fontPresetRawValue) ?? .rounded }
        set { fontPresetRawValue = newValue.rawValue }
    }
}
