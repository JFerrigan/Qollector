import Foundation
import SwiftData

typealias AppSettings = QollectorSchemaV4.AppSettings

extension QollectorSchemaV4.AppSettings {
    convenience init(
        preferredRatingStyle: RatingStyle = .stars,
        fontPreset: AppFontPreset = .rounded,
        backgroundColor: AppColorPreset = .paper,
        uiColor: AppColorPreset = .rose,
        didSeedSampleLibrary: Bool = false
    ) {
        self.init(
            preferredRatingStyleRawValue: preferredRatingStyle.rawValue,
            fontPresetRawValue: fontPreset.rawValue,
            backgroundColorRawValue: backgroundColor.rawValue,
            uiColorRawValue: uiColor.rawValue,
            didSeedSampleLibrary: didSeedSampleLibrary
        )
    }

    var preferredRatingStyle: RatingStyle {
        get { RatingStyle(rawValue: preferredRatingStyleRawValue) ?? .stars }
        set { preferredRatingStyleRawValue = newValue.rawValue }
    }

    var backgroundColor: AppColorPreset {
        get { AppColorPreset(rawValue: backgroundColorRawValue) ?? .paper }
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
}
