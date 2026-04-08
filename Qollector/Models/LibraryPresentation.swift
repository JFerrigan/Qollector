import Foundation

struct RecordLibraryPresentation {
    let library: Library?
    let snapshot: LibraryCardSnapshot
    let allDetails: [(String, String)]
    let showsRating: Bool
    let showsTags: Bool

    init(record: RecordItem, profile: LibraryRecordProfile?) {
        if let profile {
            let library = profile.library
            let values = profile.fieldValues
            self.library = library
            self.snapshot = LibraryCardSnapshot(library: library, fieldValues: values)
            let hiddenFieldIDs = Set([library.cardConfiguration.titleFieldID, library.cardConfiguration.subtitleFieldID].compactMap { $0 })
            self.allDetails = library.fieldDefinitions.compactMap { field in
                guard !hiddenFieldIDs.contains(field.id) else { return nil }
                let value = values[field.id, default: ""].trimmingCharacters(in: .whitespacesAndNewlines)
                guard !value.isEmpty else { return nil }
                return (field.label, value)
            }
            self.showsRating = library.cardConfiguration.showsRating
            self.showsTags = library.cardConfiguration.showsTags
        } else {
            let preset = LibraryPresetDefinition.vinyl
            let values = LibraryStore.vinylFieldValues(for: record)
            self.library = nil
            self.snapshot = LibraryCardSnapshot(
                fieldDefinitions: preset.fields,
                cardConfiguration: preset.cardConfiguration,
                fieldValues: values
            )
            self.allDetails = [
                ("Year", record.releaseYear.map(String.init) ?? ""),
                ("Genre", record.genre)
            ].filter { !$0.1.isEmpty }
            self.showsRating = true
            self.showsTags = true
        }
    }
}
