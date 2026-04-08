import SwiftData
import SwiftUI

struct SettingsPageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                PageSectionHeader(
                    eyebrow: "Settings",
                    title: "Library Preferences",
                    subtitle: "Adjust how ratings are shown across the app."
                )

                VStack(alignment: .leading, spacing: 16) {
                    Text("Rating Display")
                        .font(.headline)

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

                    Text("Stored scores stay intact. This only changes how ratings are shown and edited.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .cardSurface(AppTheme.surfaceSky)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Roadmap")
                        .font(.headline)
                    Text("The foundation is offline-first. Remote catalog search can be added later through the `CatalogProvider` boundary.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .cardSurface(AppTheme.surfaceRose)
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

