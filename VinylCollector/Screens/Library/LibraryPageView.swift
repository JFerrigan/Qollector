import SwiftData
import SwiftUI

struct LibraryPageView: View {
    @Query(sort: \RecordItem.updatedAt, order: .reverse) private var records: [RecordItem]
    @Query private var settings: [AppSettings]
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                summaryBanner

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
        .background(AppTheme.background)
        .accessibilityIdentifier("page.library")
    }

    private var summaryBanner: some View {
        HStack {
            Text("\(records.count)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)
            Spacer()
            Image(systemName: "square.stack.3d.up.fill")
                .font(.title2)
                .foregroundStyle(AppTheme.textPrimary)
        }
        .cardSurface(AppTheme.surfaceButter)
    }

    private var emptyState: some View {
        Image(systemName: "square.stack.3d.up")
            .font(.system(size: 28))
            .foregroundStyle(AppTheme.textSecondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(AppTheme.secondaryBackground)
    }

    private var currentRatingStyle: RatingStyle {
        settings.first?.preferredRatingStyle ?? .stars
    }
}
