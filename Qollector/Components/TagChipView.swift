import SwiftUI

struct TagChipView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let title: String
    let colorToken: VinylColorToken

    var body: some View {
        Text(title)
            .font(fontPreset.textStyle(.caption, weight: .semibold))
            .foregroundStyle(palette.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(colorToken.color.opacity(0.55))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(palette.line.opacity(0.35), lineWidth: 1)
            )
    }
}
