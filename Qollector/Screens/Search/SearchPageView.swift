import SwiftData
import SwiftUI

struct SearchPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Query(sort: \RecordItem.title) private var records: [RecordItem]
    @Query private var settings: [AppSettings]
    @State private var searchText = ""
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                TextField("Search", text: $searchText)
                    .font(fontPreset.textStyle(.body))
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                            .fill(palette.secondaryBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                            .stroke(palette.line.opacity(0.7), lineWidth: 1)
                    )

                if filteredRecords.isEmpty {
                    Image(systemName: "magnifyingglass")
                        .font(fontPreset.font(size: 24))
                        .foregroundStyle(palette.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface(palette.secondaryBackground)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredRecords) { record in
                            Button {
                                onSelectRecord(record)
                            } label: {
                                RecordCardView(record: record, ratingStyle: currentRatingStyle)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(AppTheme.outerPadding)
        }
        .background(palette.background)
        .accessibilityIdentifier("page.search")
    }

    private var filteredRecords: [RecordItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return records }
        let normalized = query.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current).lowercased()

        return records.filter { record in
            let values = [
                record.title,
                record.artist,
                record.genre,
                record.notes,
                record.tags.map(\.name).joined(separator: " ")
            ]
            .joined(separator: " ")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .lowercased()

            return values.contains(normalized)
        }
    }

    private var currentRatingStyle: RatingStyle {
        settings.first?.preferredRatingStyle ?? .stars
    }
}
