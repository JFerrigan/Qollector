import SwiftData
import SwiftUI

struct SettingsPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Environment(\.modelContext) private var modelContext
    @State private var currentSettings: AppSettings?

    var body: some View {
        Group {
            if let currentSettings {
                settingsContent(currentSettings)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(palette.background)
            }
        }
        .task {
            loadSettingsIfNeeded()
        }
        .accessibilityIdentifier("page.settings")
    }

    private func settingsContent(_ currentSettings: AppSettings) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                segmentedSelector(
                    options: RatingStyle.allCases,
                    selection: currentSettings.preferredRatingStyle,
                    title: \.title,
                    action: { updateRatingStyle($0, settings: currentSettings) }
                )
                .cardSurface(palette.surfaceSky)

                VStack(alignment: .leading, spacing: 16) {
                    colorRail(
                        options: AppColorPreset.allCases,
                        selection: currentSettings.backgroundColor,
                        action: { updateBackgroundColor($0, settings: currentSettings) }
                    )

                    colorRail(
                        options: AppColorPreset.allCases,
                        selection: currentSettings.uiColor,
                        action: { updateUIColor($0, settings: currentSettings) }
                    )
                }
                .cardSurface(palette.surfaceButter)

                fontSelector(currentSettings)
                .cardSurface(palette.surfaceRose)
            }
            .padding(AppTheme.outerPadding)
        }
        .background(palette.background)
    }

    private func fontSelector(_ currentSettings: AppSettings) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(AppFontPreset.allCases) { preset in
                    Button {
                        updateFontPreset(preset, settings: currentSettings)
                    } label: {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Spacer(minLength: 0)

                                Circle()
                                    .fill(currentSettings.fontPreset == preset ? palette.accentFill : palette.line.opacity(0.35))
                                    .frame(width: 10, height: 10)
                            }

                            Text(preset.title)
                                .font(preset.font(size: 24, weight: .semibold))
                                .foregroundStyle(palette.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(width: 168, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(fontCardFill(isSelected: currentSettings.fontPreset == preset))
                        )
                        .overlay(fontCardStroke(isSelected: currentSettings.fontPreset == preset))
                    }
                    .buttonStyle(.plain)
                }
            }
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
        options: [AppColorPreset],
        selection: AppColorPreset,
        action: @escaping (AppColorPreset) -> Void
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(options) { option in
                    Button {
                        action(option)
                    } label: {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(option.color)
                            .frame(width: 96, height: 64)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
                            )
                            .overlay(alignment: .topTrailing) {
                                if selection == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(fontPreset.textStyle(.caption))
                                        .foregroundStyle(palette.accentFill)
                                        .padding(8)
                                }
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(colorCardFill(isSelected: selection == option))
                            )
                            .overlay(colorCardStroke(isSelected: selection == option))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
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

    private func updateRatingStyle(_ style: RatingStyle, settings: AppSettings) {
        settings.preferredRatingStyle = style
        try? modelContext.save()
    }

    private func updateFontPreset(_ preset: AppFontPreset, settings: AppSettings) {
        settings.fontPreset = preset
        try? modelContext.save()
    }

    private func updateBackgroundColor(_ color: AppColorPreset, settings: AppSettings) {
        settings.backgroundColor = color
        try? modelContext.save()
    }

    private func updateUIColor(_ color: AppColorPreset, settings: AppSettings) {
        settings.uiColor = color
        try? modelContext.save()
    }

    private func loadSettingsIfNeeded() {
        guard currentSettings == nil else { return }
        currentSettings = AppBootstrap.fetchOrCreateSettings(in: modelContext)
    }
}
