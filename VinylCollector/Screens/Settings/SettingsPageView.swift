import SwiftData
import SwiftUI

struct SettingsPageView: View {
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
                .cardSurface(AppTheme.surfaceSky)
            }
            .padding(AppTheme.outerPadding)
        }
        .background(AppTheme.background)
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
