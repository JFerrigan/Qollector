import Foundation
import SwiftData

enum QollectorSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    static let models: [any PersistentModel.Type] = [
        RecordItem.self,
        Tag.self,
        AppSettings.self,
    ]

    @Model
    final class AppSettings {
        var preferredRatingStyleRawValue: String
        var backgroundPresetRawValue: String
        var fontPresetRawValue: String
        var didSeedSampleLibrary: Bool

        init(
            preferredRatingStyleRawValue: String = RatingStyle.stars.rawValue,
            backgroundPresetRawValue: String = AppBackgroundPreset.rose.rawValue,
            fontPresetRawValue: String = AppFontPreset.rounded.rawValue,
            didSeedSampleLibrary: Bool = false
        ) {
            self.preferredRatingStyleRawValue = preferredRatingStyleRawValue
            self.backgroundPresetRawValue = backgroundPresetRawValue
            self.fontPresetRawValue = fontPresetRawValue
            self.didSeedSampleLibrary = didSeedSampleLibrary
        }
    }
}

enum QollectorSchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)
    static let models: [any PersistentModel.Type] = [
        RecordItem.self,
        Tag.self,
        AppSettings.self,
    ]

    @Model
    final class AppSettings {
        var preferredRatingStyleRawValue: String
        var backgroundPresetRawValue: String
        var fontPresetRawValue: String
        var backgroundColorRawValue: String
        var uiColorRawValue: String
        var didSeedSampleLibrary: Bool

        init(
            preferredRatingStyleRawValue: String = RatingStyle.stars.rawValue,
            backgroundPresetRawValue: String = AppBackgroundPreset.rose.rawValue,
            fontPresetRawValue: String = AppFontPreset.rounded.rawValue,
            backgroundColorRawValue: String = AppColorPreset.paper.rawValue,
            uiColorRawValue: String = AppColorPreset.rose.rawValue,
            didSeedSampleLibrary: Bool = false
        ) {
            self.preferredRatingStyleRawValue = preferredRatingStyleRawValue
            self.backgroundPresetRawValue = backgroundPresetRawValue
            self.fontPresetRawValue = fontPresetRawValue
            self.backgroundColorRawValue = backgroundColorRawValue
            self.uiColorRawValue = uiColorRawValue
            self.didSeedSampleLibrary = didSeedSampleLibrary
        }
    }
}

enum QollectorSchemaV3: VersionedSchema {
    static let versionIdentifier = Schema.Version(3, 0, 0)
    static let models: [any PersistentModel.Type] = [
        RecordItem.self,
        Tag.self,
        AppSettings.self,
    ]

    @Model
    final class AppSettings {
        var preferredRatingStyleRawValue: String
        var fontPresetRawValue: String
        var backgroundColorRawValue: String
        var uiColorRawValue: String
        var didSeedSampleLibrary: Bool

        init(
            preferredRatingStyleRawValue: String = RatingStyle.stars.rawValue,
            fontPresetRawValue: String = AppFontPreset.rounded.rawValue,
            backgroundColorRawValue: String = AppColorPreset.paper.rawValue,
            uiColorRawValue: String = AppColorPreset.rose.rawValue,
            didSeedSampleLibrary: Bool = false
        ) {
            self.preferredRatingStyleRawValue = preferredRatingStyleRawValue
            self.fontPresetRawValue = fontPresetRawValue
            self.backgroundColorRawValue = backgroundColorRawValue
            self.uiColorRawValue = uiColorRawValue
            self.didSeedSampleLibrary = didSeedSampleLibrary
        }
    }
}

enum QollectorMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        QollectorSchemaV1.self,
        QollectorSchemaV2.self,
        QollectorSchemaV3.self,
    ]

    static let stages: [MigrationStage] = [
        .custom(
            fromVersion: QollectorSchemaV1.self,
            toVersion: QollectorSchemaV2.self,
            willMigrate: nil,
            didMigrate: migrateSettingsToSplitColors
        ),
        .lightweight(
            fromVersion: QollectorSchemaV2.self,
            toVersion: QollectorSchemaV3.self
        ),
    ]

    private static func migrateSettingsToSplitColors(_ context: ModelContext) throws {
        let settings = try context.fetch(FetchDescriptor<QollectorSchemaV2.AppSettings>())

        for setting in settings {
            let colors = colors(forLegacyPresetRawValue: setting.backgroundPresetRawValue)
            setting.backgroundColorRawValue = colors.background.rawValue
            setting.uiColorRawValue = colors.ui.rawValue
        }

        if context.hasChanges {
            try context.save()
        }
    }

    private static func colors(forLegacyPresetRawValue rawValue: String) -> (background: AppColorPreset, ui: AppColorPreset) {
        switch AppBackgroundPreset(rawValue: rawValue) {
        case .paper:
            return (.paper, .rose)
        case .rose:
            return (.rose, .rose)
        case .mint:
            return (.mint, .mint)
        case .sky:
            return (.sky, .sky)
        case .peach:
            return (.peach, .peach)
        case nil:
            return (.paper, .rose)
        }
    }
}
