import SwiftData
import SwiftUI

struct LibraryPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Query(sort: \RecordItem.updatedAt, order: .reverse) private var records: [RecordItem]
    @Query private var settings: [AppSettings]
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                if records.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(records) { record in
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
        .accessibilityIdentifier("page.library")
    }

    private var emptyState: some View {
        Image(systemName: "square.stack.3d.up")
            .font(fontPreset.font(size: 28))
            .foregroundStyle(palette.textSecondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(palette.secondaryBackground)
    }

    private var currentRatingStyle: RatingStyle {
        settings.first?.preferredRatingStyle ?? .stars
    }
}
