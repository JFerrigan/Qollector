import SwiftData
import SwiftUI

struct LibraryPageView: View {
    @Query(sort: \RecordItem.updatedAt, order: .reverse) private var records: [RecordItem]
    @Query private var settings: [AppSettings]
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                PageSectionHeader(
                    eyebrow: "Collection",
                    title: "Your Vinyl Shelf",
                    subtitle: "Swipe sideways to search, add a record, or change settings."
                )

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
            VStack(alignment: .leading, spacing: 6) {
                Text("\(records.count) records")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                Text("Built for local-first collecting with tags, notes, and icon recipes.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            }
            Spacer()
            Image(systemName: "square.stack.3d.up.fill")
                .font(.title2)
                .foregroundStyle(AppTheme.textPrimary)
        }
        .cardSurface(AppTheme.surfaceButter)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Nothing on the shelf yet.")
                .font(.headline)
            Text("Swipe right to add your first record and it will land here.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(AppTheme.secondaryBackground)
    }

    private var currentRatingStyle: RatingStyle {
        settings.first?.preferredRatingStyle ?? .stars
    }
}

