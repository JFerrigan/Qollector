import SwiftData

enum LibraryStore {
    static func fetchOrCreateDefaultVinylLibrary(in modelContext: ModelContext) -> Library {
        if let existing = ((try? modelContext.fetch(FetchDescriptor<Library>())) ?? []).first(where: { $0.presetKind == .vinyl }) {
            return existing
        }

        let preset = LibraryPresetDefinition.vinyl
        let library = Library(
            name: preset.name,
            presetKind: preset.kind,
            fieldDefinitions: preset.fields,
            cardConfiguration: preset.cardConfiguration
        )
        modelContext.insert(library)
        try? modelContext.save()
        return library
    }

    static func createLibrary(from draft: LibraryDraft, in modelContext: ModelContext) -> Library {
        let library = Library(
            name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines),
            presetKind: draft.presetKind,
            fieldDefinitions: draft.fieldDefinitions,
            cardConfiguration: draft.cardConfiguration
        )
        modelContext.insert(library)
        try? modelContext.save()
        return library
    }

    static func profileMap(from profiles: [LibraryRecordProfile]) -> [PersistentIdentifier: LibraryRecordProfile] {
        Dictionary(uniqueKeysWithValues: profiles.map { ($0.record.persistentModelID, $0) })
    }

    static func ensureProfilesExist(for records: [RecordItem], in modelContext: ModelContext) {
        let library = fetchOrCreateDefaultVinylLibrary(in: modelContext)
        let existingProfiles = (try? modelContext.fetch(FetchDescriptor<LibraryRecordProfile>())) ?? []
        let existingIDs = Set(existingProfiles.map(\.record.persistentModelID))

        for record in records where !existingIDs.contains(record.persistentModelID) {
            let profile = LibraryRecordProfile(
                library: library,
                record: record,
                fieldValues: vinylFieldValues(for: record)
            )
            modelContext.insert(profile)
        }

        try? modelContext.save()
    }

    static func vinylFieldValues(for record: RecordItem) -> [String: String] {
        var values: [String: String] = [
            "title": record.title,
            "artist": record.artist
        ]

        if let year = record.releaseYear {
            values["year"] = String(year)
        }

        if !record.genre.isEmpty {
            values["genre"] = record.genre
        }

        return values
    }
}
