import SwiftUI

struct RecordCardView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let record: RecordItem
    let ratingStyle: RatingStyle

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            RecordArtworkView(recipe: record.iconRecipe, size: 86)

            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title)
                        .font(fontPreset.textStyle(.headline, weight: .semibold))
                        .foregroundStyle(palette.textPrimary)
                    Text(record.artist)
                        .font(fontPreset.textStyle(.subheadline))
                        .foregroundStyle(palette.textSecondary)
                }

                HStack(spacing: 10) {
                    if let releaseYear = record.releaseYear {
                        Label("\(releaseYear)", systemImage: "calendar")
                    }

                    if !record.genre.isEmpty {
                        Label(record.genre, systemImage: "music.note.list")
                    }
                }
                .font(.caption)
                .foregroundStyle(palette.textSecondary)

                Text(formattedRating)
                    .font(fontPreset.textStyle(.caption, weight: .semibold))
                    .foregroundStyle(palette.textPrimary)

                if !record.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(record.tags, id: \.persistentModelID) { tag in
                                TagChipView(title: tag.name, colorToken: tag.colorToken)
                            }
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .cardSurface(palette.secondaryBackground)
    }

    private var formattedRating: String {
        switch ratingStyle {
        case .stars:
            let stars = max(1, Int(round(Double(record.ratingValue) / 2.0)))
            return String(repeating: "★", count: stars)
        case .tenPoint:
            return "\(record.ratingValue)/10"
        }
    }
}
