import SwiftData
import SwiftUI

struct AddRecordPageView: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]
    @Query(sort: \Library.createdAt) private var libraries: [Library]
    @Binding var selectedLibraryID: PersistentIdentifier?
    @State private var draft = RecordDraft()
    @State private var isCreatingLibrary = false
    let onSaveCompleted: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Library")
                        .font(fontPreset.textStyle(.headline, weight: .semibold))
                        .foregroundStyle(palette.textPrimary)

                    if libraries.isEmpty {
                        Button("Create Your First Library") {
                            isCreatingLibrary = true
                        }
                        .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                    } else {
                        LibraryPickerBar(
                            libraries: libraries,
                            selectedLibraryID: $selectedLibraryID,
                            trailingActionTitle: "New Library"
                        ) {
                            isCreatingLibrary = true
                        }
                    }
                }
                .cardSurface(palette.surfaceButter)

                if let selectedLibrary {
                    RecordFormView(
                        library: selectedLibrary,
                        title: "",
                        saveButtonTitle: "Save",
                        ratingStyle: settings.first?.preferredRatingStyle ?? .stars,
                        draft: $draft
                    ) {
                        RecordEditor.createRecord(from: draft, in: modelContext)
                        draft = RecordDraft(library: selectedLibrary)
                        onSaveCompleted()
                    }
                }
            }
            .padding(AppTheme.outerPadding)
        }
        .background(palette.background)
        .sheet(isPresented: $isCreatingLibrary) {
            LibraryBuilderView { libraryDraft in
                let library = LibraryStore.createLibrary(from: libraryDraft, in: modelContext)
                selectedLibraryID = library.persistentModelID
                draft = RecordDraft(library: library)
            }
        }
        .task {
            if libraries.isEmpty {
                let library = LibraryStore.fetchOrCreateDefaultVinylLibrary(in: modelContext)
                selectedLibraryID = library.persistentModelID
                draft = RecordDraft(library: library)
            } else if selectedLibraryID == nil {
                selectedLibraryID = libraries.first?.persistentModelID
                draft = RecordDraft(library: selectedLibrary)
            }
        }
        .onChange(of: selectedLibraryID) { _, _ in
            if let selectedLibrary {
                draft = RecordDraft(library: selectedLibrary)
            }
        }
        .accessibilityIdentifier("page.add")
    }

    private var selectedLibrary: Library? {
        if let selectedLibraryID {
            return libraries.first(where: { $0.persistentModelID == selectedLibraryID })
        }

        return libraries.first
    }
}
