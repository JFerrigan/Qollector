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
                previewPanel

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Rating", subtitle: "Choose how scores read across the app.")
                    segmentedSelector(
                        options: RatingStyle.allCases,
                        selection: activeSettings.preferredRatingStyle,
                        title: \.title,
                        action: updateRatingStyle
                    )
                }
                .cardSurface(palette.surfaceSky)

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Color", subtitle: "Set the page atmosphere first, then the UI tone.")
                    colorRail(
                        title: "Background",
                        options: AppColorPreset.allCases,
                        selection: activeSettings.backgroundColor,
                        action: updateBackgroundColor
                    )

                    colorRail(
                        title: "UI Elements",
                        options: AppColorPreset.allCases,
                        selection: activeSettings.uiColor,
                        action: updateUIColor
                    )
                }
                .cardSurface(palette.surfaceButter)

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Font", subtitle: "Each card previews the face directly.")
                    fontSelector
                }
                .cardSurface(palette.surfaceRose)
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

    private var previewPanel: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Current Mood")
                .font(fontPreset.textStyle(.caption, weight: .semibold))
                .foregroundStyle(palette.textSecondary)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 10) {
                Text("Qollector")
                    .font(fontPreset.font(size: 30, weight: .bold))
                    .foregroundStyle(palette.textPrimary)

                Text("Type, background, and interface color all update together here before the rest of the app.")
                    .font(fontPreset.textStyle(.subheadline))
                    .foregroundStyle(palette.textSecondary)
            }

            HStack(spacing: 12) {
                previewSwatch(title: "Background", color: activeSettings.backgroundColor.color)
                previewSwatch(title: "UI", color: activeSettings.uiColor.color)
            }

            HStack(spacing: 12) {
                previewTile(title: "Library", subtitle: "Soft surfaces", fill: palette.secondaryBackground)
                previewTile(title: "Accent", subtitle: "Action color", fill: palette.accentFill, foreground: palette.accentContent)
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            activeSettings.backgroundColor.color.opacity(0.95),
                            activeSettings.uiColor.color.opacity(0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(palette.line.opacity(0.65), lineWidth: 1)
        )
    }

    private var fontSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(AppFontPreset.allCases) { preset in
                    Button {
                        updateFontPreset(preset)
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(preset.title)
                                    .font(fontPreset.textStyle(.caption, weight: .semibold))
                                    .foregroundStyle(palette.textSecondary)

                                Spacer(minLength: 0)

                                Circle()
                                    .fill(activeSettings.fontPreset == preset ? palette.accentFill : palette.line.opacity(0.35))
                                    .frame(width: 10, height: 10)
                            }

                            Text("Ag")
                                .font(preset.font(size: 34, weight: .bold))
                                .foregroundStyle(palette.textPrimary)

                            Text("Vinyl archive")
                                .font(preset.textStyle(.subheadline, weight: .semibold))
                                .foregroundStyle(palette.textPrimary)

                            Text("Warm, readable, distinct.")
                                .font(preset.textStyle(.caption))
                                .foregroundStyle(palette.textSecondary)
                        }
                        .frame(width: 168, alignment: .leading)
                        .padding(16)
                        .background(fontCardFill(isSelected: activeSettings.fontPreset == preset))
                        .overlay(fontCardStroke(isSelected: activeSettings.fontPreset == preset))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(fontPreset.textStyle(.headline, weight: .semibold))
                .foregroundStyle(palette.textPrimary)

            Text(subtitle)
                .font(fontPreset.textStyle(.subheadline))
                .foregroundStyle(palette.textSecondary)
        }
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

    private func colorRail(
        title: String,
        options: [AppColorPreset],
        selection: AppColorPreset,
        action: @escaping (AppColorPreset) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                .foregroundStyle(palette.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(options) { option in
                        Button {
                            action(option)
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(option.color)
                                    .frame(width: 96, height: 64)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                    )

                                HStack {
                                    Text(option.title)
                                        .font(fontPreset.textStyle(.caption, weight: .semibold))
                                        .foregroundStyle(palette.textPrimary)

                                    Spacer(minLength: 0)

                                    if selection == option {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(fontPreset.textStyle(.caption))
                                            .foregroundStyle(palette.accentFill)
                                    }
                                }
                            }
                            .frame(width: 108, alignment: .leading)
                            .padding(10)
                            .background(colorCardFill(isSelected: selection == option))
                            .overlay(colorCardStroke(isSelected: selection == option))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func previewSwatch(title: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(fontPreset.textStyle(.caption, weight: .semibold))
                .foregroundStyle(palette.textSecondary)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(color)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func previewTile(title: String, subtitle: String, fill: Color, foreground: Color? = nil) -> some View {
        let textColor = foreground ?? palette.textPrimary

        return VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                .foregroundStyle(textColor)

            Text(subtitle)
                .font(fontPreset.textStyle(.caption))
                .foregroundStyle(textColor.opacity(0.78))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(fill)
        )
    }

    private func selectionFill(isSelected: Bool) -> Color {
        isSelected ? palette.accentFill.opacity(0.18) : palette.secondaryBackground
    }

    private func selectionStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(isSelected ? palette.accentFill : palette.line.opacity(0.7), lineWidth: isSelected ? 2 : 1)
    }

    private func colorCardFill(isSelected: Bool) -> Color {
        isSelected ? palette.accentFill.opacity(0.14) : palette.secondaryBackground.opacity(0.84)
    }

    private func colorCardStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .stroke(isSelected ? palette.accentFill : palette.line.opacity(0.45), lineWidth: isSelected ? 2 : 1)
    }

    private func fontCardFill(isSelected: Bool) -> Color {
        isSelected ? palette.accentFill.opacity(0.12) : palette.secondaryBackground
    }

    private func fontCardStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(isSelected ? palette.accentFill : palette.line.opacity(0.45), lineWidth: isSelected ? 2 : 1)
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
