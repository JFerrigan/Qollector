import SwiftData
import SwiftUI

struct SettingsPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 16) {
                    Picker("Rating Style", selection: Binding(
                        get: { activeSettings.preferredRatingStyle },
                        set: { newValue in
                            activeSettings.preferredRatingStyle = newValue
                            try? modelContext.save()
                        }
                    )) {
                        ForEach(RatingStyle.allCases) { style in
                            Text(style.title).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .cardSurface(palette.surfaceSky)

                VStack(alignment: .leading, spacing: 16) {
                    Picker("Font", selection: Binding(
                        get: { activeSettings.fontPreset },
                        set: { newValue in
                            activeSettings.fontPreset = newValue
                            try? modelContext.save()
                        }
                    )) {
                        ForEach(AppFontPreset.allCases) { preset in
                            Text(preset.title).tag(preset)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .cardSurface(palette.surfaceRose)

                VStack(alignment: .leading, spacing: 16) {
                    Picker("Background", selection: Binding(
                        get: { activeSettings.backgroundPreset },
                        set: { newValue in
                            activeSettings.backgroundPreset = newValue
                            try? modelContext.save()
                        }
                    )) {
                        ForEach(AppBackgroundPreset.allCases) { preset in
                            Text(preset.title).tag(preset)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .cardSurface(palette.surfaceButter)
            }
            .padding(AppTheme.outerPadding)
        }
        .background(palette.background)
        .task {
            _ = activeSettings
        }
        .accessibilityIdentifier("page.settings")
    }

    private var activeSettings: AppSettings {
        if let existing = settings.first {
            return existing
        }

        return AppBootstrap.fetchOrCreateSettings(in: modelContext)
    }
}
