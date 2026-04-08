import Foundation
import SwiftData

struct RecordDraft {
    var title = ""
    var artist = ""
    var releaseYearText = ""
    var genre = ""
    var ratingValue = 8
    var notes = ""
    var tagsText = ""
    var iconRecipe = RecordIconRecipeFactory.makeRecipe(title: "", artist: "")

    init() {}

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
        self.title = title
        self.artist = artist
        self.releaseYearText = releaseYearText
        self.genre = genre
        self.ratingValue = ratingValue
        self.notes = notes
        self.tagsText = tagsText
        self.iconRecipe = iconRecipe
    }

    init(record: RecordItem) {
        title = record.title
        artist = record.artist
        releaseYearText = record.releaseYear.map(String.init) ?? ""
        genre = record.genre
        ratingValue = record.ratingValue
        notes = record.notes
        tagsText = record.tags.map(\.name).sorted().joined(separator: ", ")
        iconRecipe = record.iconRecipe
    }

    var releaseYear: Int? {
        let trimmed = releaseYearText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Int(trimmed)
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !artist.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

enum RecordEditor {
    static func createRecord(from draft: RecordDraft, in modelContext: ModelContext) {
        let tags = resolvedTags(from: draft.tagsText, in: modelContext)
        let record = RecordItem(
            title: draft.title.trimmingCharacters(in: .whitespacesAndNewlines),
            artist: draft.artist.trimmingCharacters(in: .whitespacesAndNewlines),
            releaseYear: draft.releaseYear,
            genre: draft.genre.trimmingCharacters(in: .whitespacesAndNewlines),
            ratingValue: draft.ratingValue,
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            iconRecipe: draft.iconRecipe,
            tags: tags
        )
        modelContext.insert(record)
        try? modelContext.save()
    }

    static func update(record: RecordItem, from draft: RecordDraft, in modelContext: ModelContext) {
        record.title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        record.artist = draft.artist.trimmingCharacters(in: .whitespacesAndNewlines)
        record.releaseYear = draft.releaseYear
        record.genre = draft.genre.trimmingCharacters(in: .whitespacesAndNewlines)
        record.ratingValue = draft.ratingValue
        record.notes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        record.iconRecipe = draft.iconRecipe
        record.tags = resolvedTags(from: draft.tagsText, in: modelContext)
        record.updatedAt = .now
        try? modelContext.save()
    }

    static func delete(record: RecordItem, in modelContext: ModelContext) {
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
}
