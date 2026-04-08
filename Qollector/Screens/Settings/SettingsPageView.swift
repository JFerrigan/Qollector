import SwiftData
import SwiftUI

struct SettingsPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Rating")
                    segmentedSelector(
                        options: RatingStyle.allCases,
                        selection: activeSettings.preferredRatingStyle,
                        title: \.title,
                        action: updateRatingStyle
                    )
                }
                .cardSurface(palette.surfaceSky)

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Font")
                    fontSelector
                }
                .cardSurface(palette.surfaceRose)

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Background")
                    colorSelector(
                        options: AppColorPreset.allCases,
                        selection: activeSettings.backgroundColor,
                        action: updateBackgroundColor
                    )
                }
                .cardSurface(palette.surfaceButter)

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("UI Elements")
                    colorSelector(
                        options: AppColorPreset.allCases,
                        selection: activeSettings.uiColor,
                        action: updateUIColor
                    )
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

    private var fontSelector: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
            ForEach(AppFontPreset.allCases) { preset in
                Button {
                    updateFontPreset(preset)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(preset.title)
                            .font(preset.textStyle(.headline, weight: .semibold))
                            .foregroundStyle(palette.textPrimary)

                        Text("Aa Bb Cc")
                            .font(preset.textStyle(.caption))
                            .foregroundStyle(palette.textSecondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(selectionFill(isSelected: activeSettings.fontPreset == preset))
                    .overlay(selectionStroke(isSelected: activeSettings.fontPreset == preset))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(fontPreset.textStyle(.headline, weight: .semibold))
            .foregroundStyle(palette.textPrimary)
    }

    private func segmentedSelector<Option: Identifiable & Hashable>(
        options: [Option],
        selection: Option,
        title: KeyPath<Option, String>,
        action: @escaping (Option) -> Void
    ) -> some View {
        HStack(spacing: 10) {
            ForEach(options) { option in
                Button {
                    action(option)
                } label: {
                    Text(option[keyPath: title])
                        .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                        .foregroundStyle(selection == option ? palette.accentContent : palette.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selection == option ? palette.accentFill : palette.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(palette.line.opacity(selection == option ? 0 : 0.7), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func colorSelector(
        options: [AppColorPreset],
        selection: AppColorPreset,
        action: @escaping (AppColorPreset) -> Void
    ) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 10)], spacing: 10) {
            ForEach(options) { option in
                Button {
                    action(option)
                } label: {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(option.color)
                            .frame(width: 18, height: 18)

                        Text(option.title)
                            .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                            .foregroundStyle(palette.textPrimary)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(selectionFill(isSelected: selection == option))
                    .overlay(selectionStroke(isSelected: selection == option))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func selectionFill(isSelected: Bool) -> Color {
        isSelected ? palette.accentFill.opacity(0.18) : palette.secondaryBackground
    }

    private func selectionStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(isSelected ? palette.accentFill : palette.line.opacity(0.7), lineWidth: isSelected ? 2 : 1)
    }

    private func updateRatingStyle(_ style: RatingStyle) {
        activeSettings.preferredRatingStyle = style
        try? modelContext.save()
    }

    private func updateFontPreset(_ preset: AppFontPreset) {
        activeSettings.fontPreset = preset
        try? modelContext.save()
    }

    private func updateBackgroundColor(_ color: AppColorPreset) {
        activeSettings.backgroundColor = color
        try? modelContext.save()
    }

    private func updateUIColor(_ color: AppColorPreset) {
        activeSettings.uiColor = color
        try? modelContext.save()
    }
}
