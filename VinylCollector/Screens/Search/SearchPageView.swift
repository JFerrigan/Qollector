import SwiftData
import SwiftUI

struct SearchPageView: View {
    @Query(sort: \RecordItem.title) private var records: [RecordItem]
    @Query private var settings: [AppSettings]
    @State private var searchText = ""
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                PageSectionHeader(
                    eyebrow: "Search",
                    title: "Find Something Fast",
                    subtitle: "Search your local library by title, artist, notes, genre, or tags."
                )

                TextField("Search local records", text: $searchText)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                            .fill(AppTheme.secondaryBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                            .stroke(AppTheme.line.opacity(0.7), lineWidth: 1)
                    )

                if filteredRecords.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(searchText.isEmpty ? "Search your shelf." : "No matching records.")
                            .font(.headline)
                        Text(searchText.isEmpty ? "Your records will appear here once you start filtering." : "Try a title, artist, genre, note, or tag.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface(AppTheme.secondaryBackground)
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
        .background(AppTheme.background)
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

