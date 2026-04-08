import Foundation

protocol CatalogProvider {
    func searchRecords(matching query: String) async throws -> [CatalogRecord]
}

struct CatalogRecord: Identifiable, Equatable {
    let id: String
    let title: String
    let artist: String
    let year: Int?
}

struct LocalOnlyCatalogProvider: CatalogProvider {
    func searchRecords(matching query: String) async throws -> [CatalogRecord] {
        _ = query
        return []
    }
}

