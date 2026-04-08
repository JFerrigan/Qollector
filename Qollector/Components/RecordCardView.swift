import SwiftUI

struct RecordCardView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let record: RecordItem
    let profile: LibraryRecordProfile?
    let ratingStyle: RatingStyle

    var body: some View {
        let presentation = RecordLibraryPresentation(record: record, profile: profile)

        HStack(alignment: .top, spacing: 16) {
            RecordArtworkView(recipe: record.iconRecipe, size: 86)

            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(presentation.snapshot.title)
                        .font(fontPreset.textStyle(.headline, weight: .semibold))
                        .foregroundStyle(palette.textPrimary)
                    if let subtitle = presentation.snapshot.subtitle {
                        Text(subtitle)
                            .font(fontPreset.textStyle(.subheadline))
                            .foregroundStyle(palette.textSecondary)
                    }
                }

                if !presentation.snapshot.metadata.isEmpty {
                    HStack(spacing: 10) {
                        ForEach(presentation.snapshot.metadata, id: \.self) { value in
                            Text(value)
                        }
                    }
                    .font(fontPreset.textStyle(.caption))
                    .foregroundStyle(palette.textSecondary)
                }

                if presentation.showsRating && ratingStyle == .stars {
                    StarRatingView(
                        ratingValue: record.ratingValue,
                        size: 12,
                        activeColor: palette.textPrimary,
                        inactiveColor: palette.textSecondary
                    )
                } else if presentation.showsRating {
                    Text(formattedRating)
                        .font(fontPreset.textStyle(.caption, weight: .semibold))
                        .foregroundStyle(palette.textPrimary)
                }

                if presentation.showsTags && !record.tags.isEmpty {
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
        StarRatingValue.tenPointLabel(for: record.ratingValue)
    }
}
