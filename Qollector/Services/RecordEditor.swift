import Foundation
import SwiftData

struct RecordDraft {
    var library: Library?
    var fieldValues: [String: String] = [:]
    var ratingValue = 8
    var notes = ""
    var tagsText = ""
    var iconRecipe = RecordIconRecipeFactory.makeRecipe(title: "", artist: "")

    init(library: Library? = nil) {
        self.library = library
    }

    init(
        title: String,
        artist: String,
        releaseYearText: String = "",
        genre: String = "",
        ratingValue: Int = 8,
        notes: String = "",
        tagsText: String = "",
        iconRecipe: RecordIconRecipe
    ) {
        self.library = nil
        self.fieldValues = [
            "title": title,
            "artist": artist,
            "year": releaseYearText,
            "genre": genre
        ]
        self.ratingValue = ratingValue
        self.notes = notes
        self.tagsText = tagsText
        self.iconRecipe = iconRecipe
    }

    init(record: RecordItem, library: Library?, profile: LibraryRecordProfile?) {
        self.library = library
        self.fieldValues = profile?.fieldValues ?? LibraryStore.vinylFieldValues(for: record)
        ratingValue = record.ratingValue
        notes = record.notes
        tagsText = record.tags.map(\.name).sorted().joined(separator: ", ")
        iconRecipe = record.iconRecipe
    }

    func value(for fieldID: String) -> String {
        fieldValues[fieldID, default: ""]
    }

    mutating func setValue(_ value: String, for fieldID: String) {
        fieldValues[fieldID] = value
    }

    var releaseYear: Int? {
        let trimmed = yearText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Int(trimmed)
    }

    var canSave: Bool {
        guard let library else {
            return !primaryTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !secondaryTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        return library.fieldDefinitions
            .filter(\.isRequired)
            .allSatisfy { !value(for: $0.id).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var primaryTitle: String {
        if let fieldID = library?.cardConfiguration.titleFieldID {
            return value(for: fieldID)
        }

        return value(for: "title")
    }

    var secondaryTitle: String {
        if let fieldID = library?.cardConfiguration.subtitleFieldID {
            return value(for: fieldID)
        }

        return value(for: "artist")
    }

    var yearText: String {
        if let yearField = library?.fieldDefinitions.first(where: {
            $0.type == .number && ($0.id == "year" || $0.label.localizedCaseInsensitiveContains("year"))
        }) {
            return value(for: yearField.id)
        }

        return value(for: "year")
    }

    var genreText: String {
        if let genreField = library?.fieldDefinitions.first(where: {
            $0.id == "genre" || $0.label.localizedCaseInsensitiveContains("genre")
        }) {
            return value(for: genreField.id)
        }

        return value(for: "genre")
    }
}

enum RecordEditor {
    static func createRecord(from draft: RecordDraft, in modelContext: ModelContext) {
        let library = draft.library ?? LibraryStore.fetchOrCreateDefaultVinylLibrary(in: modelContext)
        let tags = resolvedTags(from: draft.tagsText, in: modelContext)
        let record = RecordItem(
            title: draft.primaryTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            artist: draft.secondaryTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            releaseYear: draft.releaseYear,
            genre: draft.genreText.trimmingCharacters(in: .whitespacesAndNewlines),
            ratingValue: draft.ratingValue,
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            iconRecipe: draft.iconRecipe,
            tags: tags
        )
        modelContext.insert(record)

        let profile = LibraryRecordProfile(
            library: library,
            record: record,
            fieldValues: sanitizedFieldValues(from: draft.fieldValues)
        )
        modelContext.insert(profile)
        try? modelContext.save()
    }

    static func update(record: RecordItem, from draft: RecordDraft, in modelContext: ModelContext) {
        let library = draft.library ?? LibraryStore.fetchOrCreateDefaultVinylLibrary(in: modelContext)
        let profiles = (try? modelContext.fetch(FetchDescriptor<LibraryRecordProfile>())) ?? []
        let profile = profiles.first(where: { $0.record.persistentModelID == record.persistentModelID })

        record.title = draft.primaryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        record.artist = draft.secondaryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        record.releaseYear = draft.releaseYear
        record.genre = draft.genreText.trimmingCharacters(in: .whitespacesAndNewlines)
        record.ratingValue = draft.ratingValue
        record.notes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        record.iconRecipe = draft.iconRecipe
        record.tags = resolvedTags(from: draft.tagsText, in: modelContext)
        record.updatedAt = .now

        if let profile {
            profile.library = library
            profile.fieldValues = sanitizedFieldValues(from: draft.fieldValues)
        } else {
            modelContext.insert(
                LibraryRecordProfile(
                    library: library,
                    record: record,
                    fieldValues: sanitizedFieldValues(from: draft.fieldValues)
                )
            )
        }

        try? modelContext.save()
    }

    static func delete(record: RecordItem, in modelContext: ModelContext) {
        let profiles = (try? modelContext.fetch(FetchDescriptor<LibraryRecordProfile>())) ?? []
        profiles
            .filter { $0.record.persistentModelID == record.persistentModelID }
            .forEach(modelContext.delete)
        modelContext.delete(record)
        try? modelContext.save()
    }

    static func resolvedTags(from tagsText: String, in modelContext: ModelContext) -> [Tag] {
        let parsedTags = tagsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let uniqueNames = parsedTags.reduce(into: [String]()) { result, name in
            if !result.contains(where: { $0.caseInsensitiveCompare(name) == .orderedSame }) {
                result.append(name)
            }
        }

        let existingTags = (try? modelContext.fetch(FetchDescriptor<Tag>())) ?? []

        return uniqueNames.map { name in
            let normalized = normalizedTagName(name)
            if let existing = existingTags.first(where: { $0.normalizedName == normalized }) {
                return existing
            }

            let newTag = Tag(name: name, normalizedName: normalized, colorToken: suggestedColor(for: normalized))
            modelContext.insert(newTag)
            return newTag
        }
    }

    static func normalizedTagName(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .lowercased()
    }

    private static func suggestedColor(for normalizedName: String) -> VinylColorToken {
        let hash = normalizedName.unicodeScalars.reduce(0) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }
        let colors: [VinylColorToken] = [.peach, .butter, .mint, .sky, .lilac, .coral]
        return colors[hash % colors.count]
    }

    private static func sanitizedFieldValues(from values: [String: String]) -> [String: String] {
        values.reduce(into: [String: String]()) { result, item in
            let trimmed = item.value.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                result[item.key] = trimmed
            }
        }
    }
}
