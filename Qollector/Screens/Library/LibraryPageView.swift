import SwiftData
import SwiftUI

struct LibraryPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Query(sort: \RecordItem.updatedAt, order: .reverse) private var records: [RecordItem]
    @Query(sort: \Library.createdAt) private var libraries: [Library]
    @Query private var profiles: [LibraryRecordProfile]
    @Query private var settings: [AppSettings]
    @Binding var selectedLibraryID: PersistentIdentifier?
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                if !libraries.isEmpty {
                    LibraryPickerBar(libraries: libraries, selectedLibraryID: $selectedLibraryID)
                }

                if filteredRecords.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredRecords) { record in
                            Button {
                                onSelectRecord(record)
                            } label: {
                                RecordCardView(
                                    record: record,
                                    profile: profileMap[record.persistentModelID],
                                    ratingStyle: currentRatingStyle
                                )
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
        .task {
            if selectedLibraryID == nil {
                selectedLibraryID = libraries.first?.persistentModelID
            }
        }
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

    private var profileMap: [PersistentIdentifier: LibraryRecordProfile] {
        LibraryStore.profileMap(from: profiles)
    }

    private var filteredRecords: [RecordItem] {
        guard let selectedLibraryID else { return records }
        let allowed = Set(
            profiles
                .filter { $0.library.persistentModelID == selectedLibraryID }
                .map { $0.record.persistentModelID }
        )

        return records.filter { allowed.contains($0.persistentModelID) }
    }
}
