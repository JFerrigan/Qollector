import SwiftData

enum AppBootstrap {
    static func bootstrap(in modelContext: ModelContext) {
        let settings = fetchOrCreateSettings(in: modelContext)

        guard !settings.didSeedSampleLibrary else { return }
        let existingRecords = (try? modelContext.fetch(FetchDescriptor<RecordItem>())) ?? []
        guard existingRecords.isEmpty else {
            settings.didSeedSampleLibrary = true
            try? modelContext.save()
            return
        }

        let first = RecordDraft(
            title: "Heaven or Las Vegas",
            artist: "Cocteau Twins",
            releaseYearText: "1990",
            genre: "Dream Pop",
            ratingValue: 10,
            notes: "Lush and bright. Great test data for the bookshelf view.",
            tagsText: "favorite, pastel, ambient",
            iconRecipe: RecordIconRecipeFactory.makeRecipe(title: "Heaven or Las Vegas", artist: "Cocteau Twins")
        )

        let second = RecordDraft(
            title: "Discovery",
            artist: "Daft Punk",
            releaseYearText: "2001",
            genre: "Electronic",
            ratingValue: 9,
            notes: "Good contrast for metadata and tags.",
            tagsText: "party, reference",
            iconRecipe: RecordIconRecipeFactory.makeRecipe(title: "Discovery", artist: "Daft Punk")
        )

        let third = RecordDraft(
            title: "Kind of Blue",
            artist: "Miles Davis",
            releaseYearText: "1959",
            genre: "Jazz",
            ratingValue: 10,
            notes: "Classic catalog example with a calmer icon recipe.",
            tagsText: "jazz, all-time",
            iconRecipe: RecordIconRecipeFactory.makeRecipe(title: "Kind of Blue", artist: "Miles Davis")
        )

        createRecordIfNeeded(from: first, in: modelContext)
        createRecordIfNeeded(from: second, in: modelContext)
        createRecordIfNeeded(from: third, in: modelContext)

        settings.didSeedSampleLibrary = true
        try? modelContext.save()
    }

    @discardableResult
    static func fetchOrCreateSettings(in modelContext: ModelContext) -> AppSettings {
        if let existing = ((try? modelContext.fetch(FetchDescriptor<AppSettings>())) ?? []).first {
            return existing
        }

        let settings = AppSettings(preferredRatingStyleRawValue: RatingStyle.stars.rawValue)
        modelContext.insert(settings)
        try? modelContext.save()
        return settings
    }

    private static func createRecordIfNeeded(from draft: RecordDraft, in modelContext: ModelContext) {
        RecordEditor.createRecord(from: draft, in: modelContext)
    }
}
