import Foundation
import SwiftData

@Model
final class AppSettings {
    var preferredRatingStyleRawValue: String
    var backgroundPresetRawValue: String
    var fontPresetRawValue: String
    var backgroundColorRawValue: String
    var uiColorRawValue: String
    var didSeedSampleLibrary: Bool

    init(
        preferredRatingStyle: RatingStyle = .stars,
        backgroundPreset: AppBackgroundPreset = .rose,
        fontPreset: AppFontPreset = .rounded,
        backgroundColor: AppColorPreset = .paper,
        uiColor: AppColorPreset = .rose,
        didSeedSampleLibrary: Bool = false
    ) {
        self.preferredRatingStyleRawValue = preferredRatingStyle.rawValue
        self.backgroundPresetRawValue = backgroundPreset.rawValue
        self.fontPresetRawValue = fontPreset.rawValue
        self.backgroundColorRawValue = backgroundColor.rawValue
        self.uiColorRawValue = uiColor.rawValue
        self.didSeedSampleLibrary = didSeedSampleLibrary
    }

    var preferredRatingStyle: RatingStyle {
        get { RatingStyle(rawValue: preferredRatingStyleRawValue) ?? .stars }
        set { preferredRatingStyleRawValue = newValue.rawValue }
    }

    var backgroundPreset: AppBackgroundPreset {
        get { AppBackgroundPreset(rawValue: backgroundPresetRawValue) ?? .rose }
        set { backgroundPresetRawValue = newValue.rawValue }
    }

    var backgroundColor: AppColorPreset {
        get {
            AppColorPreset(rawValue: backgroundColorRawValue)
            ?? legacyColor(for: backgroundPreset)
        }
        set { backgroundColorRawValue = newValue.rawValue }
    }

    var uiColor: AppColorPreset {
        get { AppColorPreset(rawValue: uiColorRawValue) ?? .rose }
        set { uiColorRawValue = newValue.rawValue }
    }

    var fontPreset: AppFontPreset {
        get { AppFontPreset(rawValue: fontPresetRawValue) ?? .rounded }
        set { fontPresetRawValue = newValue.rawValue }
    }

    private func legacyColor(for preset: AppBackgroundPreset) -> AppColorPreset {
        switch preset {
        case .paper:
            return .paper
        case .rose:
            return .rose
        case .mint:
            return .mint
        case .sky:
            return .sky
        case .peach:
            return .peach
        }
    }
}
