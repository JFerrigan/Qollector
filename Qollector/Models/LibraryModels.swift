import Foundation
import SwiftData

enum LibraryPresetKind: String, Codable, CaseIterable, Identifiable {
    case vinyl
    case books
    case movies
    case games
    case tv
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vinyl: return "Vinyl"
        case .books: return "Books"
        case .movies: return "Movies"
        case .games: return "Games"
        case .tv: return "TV"
        case .custom: return "Custom"
        }
    }
}

enum LibraryFieldType: String, Codable, CaseIterable, Identifiable {
    case text
    case number
    case date

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

struct LibraryFieldDefinition: Codable, Identifiable, Hashable {
    var id: String
    var label: String
    var type: LibraryFieldType
    var isRequired: Bool = false

    init(id: String = UUID().uuidString, label: String, type: LibraryFieldType, isRequired: Bool = false) {
        self.id = id
        self.label = label
        self.type = type
        self.isRequired = isRequired
    }
}

struct LibraryCardConfiguration: Codable, Hashable {
    var titleFieldID: String
    var subtitleFieldID: String?
    var metadataFieldIDs: [String]
    var showsRating: Bool
    var showsTags: Bool
}

struct LibraryPresetDefinition: Identifiable {
    let kind: LibraryPresetKind
    let name: String
    let fields: [LibraryFieldDefinition]
    let cardConfiguration: LibraryCardConfiguration
    let sampleValues: [String: String]

    var id: LibraryPresetKind { kind }

    static let allCases: [LibraryPresetDefinition] = [
        .vinyl,
        .books,
        .movies,
        .games,
        .tv,
    ]

    static let vinyl = LibraryPresetDefinition(
        kind: .vinyl,
        name: "Vinyl Library",
        fields: [
            LibraryFieldDefinition(id: "title", label: "Title", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "artist", label: "Artist", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "year", label: "Year", type: .number),
            LibraryFieldDefinition(id: "genre", label: "Genre", type: .text),
        ],
        cardConfiguration: LibraryCardConfiguration(
            titleFieldID: "title",
            subtitleFieldID: "artist",
            metadataFieldIDs: ["year", "genre"],
            showsRating: true,
            showsTags: true
        ),
        sampleValues: [
            "title": "Kind of Blue",
            "artist": "Miles Davis",
            "year": "1959",
            "genre": "Jazz"
        ]
    )

    static let books = LibraryPresetDefinition(
        kind: .books,
        name: "Book Library",
        fields: [
            LibraryFieldDefinition(id: "title", label: "Title", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "author", label: "Author", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "year", label: "Published", type: .number),
            LibraryFieldDefinition(id: "format", label: "Format", type: .text),
        ],
        cardConfiguration: LibraryCardConfiguration(
            titleFieldID: "title",
            subtitleFieldID: "author",
            metadataFieldIDs: ["year", "format"],
            showsRating: true,
            showsTags: true
        ),
        sampleValues: [
            "title": "The Left Hand of Darkness",
            "author": "Ursula K. Le Guin",
            "year": "1969",
            "format": "Paperback"
        ]
    )

    static let movies = LibraryPresetDefinition(
        kind: .movies,
        name: "Movie Library",
        fields: [
            LibraryFieldDefinition(id: "title", label: "Title", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "director", label: "Director", type: .text),
            LibraryFieldDefinition(id: "year", label: "Year", type: .number),
            LibraryFieldDefinition(id: "format", label: "Format", type: .text),
        ],
        cardConfiguration: LibraryCardConfiguration(
            titleFieldID: "title",
            subtitleFieldID: "director",
            metadataFieldIDs: ["year", "format"],
            showsRating: true,
            showsTags: true
        ),
        sampleValues: [
            "title": "In the Mood for Love",
            "director": "Wong Kar-wai",
            "year": "2000",
            "format": "4K UHD"
        ]
    )

    static let games = LibraryPresetDefinition(
        kind: .games,
        name: "Game Library",
        fields: [
            LibraryFieldDefinition(id: "title", label: "Title", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "platform", label: "Platform", type: .text),
            LibraryFieldDefinition(id: "year", label: "Year", type: .number),
            LibraryFieldDefinition(id: "genre", label: "Genre", type: .text),
        ],
        cardConfiguration: LibraryCardConfiguration(
            titleFieldID: "title",
            subtitleFieldID: "platform",
            metadataFieldIDs: ["year", "genre"],
            showsRating: true,
            showsTags: true
        ),
        sampleValues: [
            "title": "Metroid Prime",
            "platform": "GameCube",
            "year": "2002",
            "genre": "Action Adventure"
        ]
    )

    static let tv = LibraryPresetDefinition(
        kind: .tv,
        name: "TV Library",
        fields: [
            LibraryFieldDefinition(id: "title", label: "Title", type: .text, isRequired: true),
            LibraryFieldDefinition(id: "creator", label: "Creator", type: .text),
            LibraryFieldDefinition(id: "year", label: "Year", type: .number),
            LibraryFieldDefinition(id: "status", label: "Status", type: .text),
        ],
        cardConfiguration: LibraryCardConfiguration(
            titleFieldID: "title",
            subtitleFieldID: "creator",
            metadataFieldIDs: ["year", "status"],
            showsRating: true,
            showsTags: true
        ),
        sampleValues: [
            "title": "Twin Peaks",
            "creator": "David Lynch",
            "year": "1990",
            "status": "Completed"
        ]
    )

    static func forKind(_ kind: LibraryPresetKind) -> LibraryPresetDefinition {
        allCases.first(where: { $0.kind == kind }) ?? .vinyl
    }
}

@Model
final class Library {
    var name: String
    var presetKindRawValue: String
    var fieldDefinitionsRawValue: String
    var cardConfigurationRawValue: String
    var createdAt: Date
    var updatedAt: Date

    init(
        name: String,
        presetKind: LibraryPresetKind,
        fieldDefinitions: [LibraryFieldDefinition],
        cardConfiguration: LibraryCardConfiguration
    ) {
        self.name = name
        self.presetKindRawValue = presetKind.rawValue
        self.fieldDefinitionsRawValue = LibraryCodec.encode(fieldDefinitions)
        self.cardConfigurationRawValue = LibraryCodec.encode(cardConfiguration)
        self.createdAt = .now
        self.updatedAt = .now
    }

    var presetKind: LibraryPresetKind {
        get { LibraryPresetKind(rawValue: presetKindRawValue) ?? .custom }
        set { presetKindRawValue = newValue.rawValue }
    }

    var fieldDefinitions: [LibraryFieldDefinition] {
        get { LibraryCodec.decode([LibraryFieldDefinition].self, from: fieldDefinitionsRawValue) ?? [] }
        set {
            fieldDefinitionsRawValue = LibraryCodec.encode(newValue)
            updatedAt = .now
        }
    }

    var cardConfiguration: LibraryCardConfiguration {
        get {
            LibraryCodec.decode(LibraryCardConfiguration.self, from: cardConfigurationRawValue)
            ?? LibraryPresetDefinition.vinyl.cardConfiguration
        }
        set {
            cardConfigurationRawValue = LibraryCodec.encode(newValue)
            updatedAt = .now
        }
    }
}

@Model
final class LibraryRecordProfile {
    @Relationship var library: Library
    @Relationship var record: RecordItem
    var fieldValuesRawValue: String
    var createdAt: Date
    var updatedAt: Date

    init(library: Library, record: RecordItem, fieldValues: [String: String]) {
        self.library = library
        self.record = record
        self.fieldValuesRawValue = LibraryCodec.encode(fieldValues)
        self.createdAt = .now
        self.updatedAt = .now
    }

    var fieldValues: [String: String] {
        get { LibraryCodec.decode([String: String].self, from: fieldValuesRawValue) ?? [:] }
        set {
            fieldValuesRawValue = LibraryCodec.encode(newValue)
            updatedAt = .now
        }
    }
}

enum LibraryCodec {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    static func encode<T: Encodable>(_ value: T) -> String {
        guard let data = try? encoder.encode(value),
              let string = String(data: data, encoding: .utf8) else {
            return ""
        }

        return string
    }

    static func decode<T: Decodable>(_ type: T.Type, from rawValue: String) -> T? {
        guard let data = rawValue.data(using: .utf8) else { return nil }
        return try? decoder.decode(type, from: data)
    }
}

struct LibraryDraft {
    var name: String
    var presetKind: LibraryPresetKind
    var fieldDefinitions: [LibraryFieldDefinition]
    var cardConfiguration: LibraryCardConfiguration
    var sampleValues: [String: String]

    init(preset: LibraryPresetDefinition) {
        self.name = preset.name
        self.presetKind = preset.kind
        self.fieldDefinitions = preset.fields
        self.cardConfiguration = preset.cardConfiguration
        self.sampleValues = preset.sampleValues
    }

    init() {
        self.init(preset: .vinyl)
        self.name = "Custom Library"
        self.presetKind = .custom
    }

    var sortedMetadataFieldIDs: [String] {
        cardConfiguration.metadataFieldIDs.filter { fieldID in
            fieldDefinitions.contains(where: { $0.id == fieldID })
        }
    }
}

struct LibraryCardSnapshot {
    let title: String
    let subtitle: String?
    let metadata: [String]

    init(library: Library, fieldValues: [String: String]) {
        self.init(
            fieldDefinitions: library.fieldDefinitions,
            cardConfiguration: library.cardConfiguration,
            fieldValues: fieldValues
        )
    }

    init(draft: LibraryDraft) {
        self.init(
            fieldDefinitions: draft.fieldDefinitions,
            cardConfiguration: draft.cardConfiguration,
            fieldValues: draft.sampleValues
        )
    }

    init(
        fieldDefinitions: [LibraryFieldDefinition],
        cardConfiguration: LibraryCardConfiguration,
        fieldValues: [String: String]
    ) {
        func value(for fieldID: String?) -> String? {
            guard let fieldID, let value = fieldValues[fieldID]?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
                return nil
            }
            return value
        }

        self.title = value(for: cardConfiguration.titleFieldID) ?? "Untitled"
        self.subtitle = value(for: cardConfiguration.subtitleFieldID)
        self.metadata = cardConfiguration.metadataFieldIDs.compactMap { fieldID in
            guard let definition = fieldDefinitions.first(where: { $0.id == fieldID }),
                  let value = value(for: fieldID) else { return nil }
            return "\(definition.label): \(value)"
        }
    }
}
