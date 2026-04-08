import SwiftUI

struct PageSectionHeader: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !eyebrow.isEmpty {
                Text(eyebrow.uppercased())
                    .font(fontPreset.textStyle(.caption, weight: .semibold))
                    .tracking(1.4)
                    .foregroundStyle(palette.textSecondary)
            }

            if !title.isEmpty {
                Text(title)
                    .font(fontPreset.font(size: 32, weight: .bold))
                    .foregroundStyle(palette.textPrimary)
            }

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(fontPreset.textStyle(.subheadline))
                    .foregroundStyle(palette.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
