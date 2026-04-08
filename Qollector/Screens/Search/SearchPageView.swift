import SwiftData
import SwiftUI

struct SearchPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Query(sort: \RecordItem.title) private var records: [RecordItem]
    @Query(sort: \Library.createdAt) private var libraries: [Library]
    @Query private var profiles: [LibraryRecordProfile]
    @Query private var settings: [AppSettings]
    @State private var searchText = ""
    @Binding var selectedLibraryID: PersistentIdentifier?
    let onSelectRecord: (RecordItem) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                if !libraries.isEmpty {
                    LibraryPickerBar(libraries: libraries, selectedLibraryID: $selectedLibraryID)
                }

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
        .accessibilityIdentifier("page.search")
        .task {
            if selectedLibraryID == nil {
                selectedLibraryID = libraries.first?.persistentModelID
            }
        }
    }

    private var filteredRecords: [RecordItem] {
        let baseRecords: [RecordItem]
        if let selectedLibraryID {
            let allowed = Set(
                profiles
                    .filter { $0.library.persistentModelID == selectedLibraryID }
                    .map { $0.record.persistentModelID }
            )
            baseRecords = records.filter { allowed.contains($0.persistentModelID) }
        } else {
            baseRecords = records
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return baseRecords }
        let normalized = query.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current).lowercased()

        return baseRecords.filter { record in
            let profileValues = profileMap[record.persistentModelID]?.fieldValues.values.joined(separator: " ") ?? ""
            let values = [
                record.title,
                record.artist,
                record.genre,
                record.notes,
                profileValues,
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

    private var profileMap: [PersistentIdentifier: LibraryRecordProfile] {
        LibraryStore.profileMap(from: profiles)
    }
}
