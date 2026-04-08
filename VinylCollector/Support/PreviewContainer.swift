import SwiftData

@MainActor
enum PreviewContainer {
    static let shared: ModelContainer = {
        let schema = Schema([
            RecordItem.self,
            Tag.self,
            AppSettings.self,
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: configuration)
        let context = container.mainContext

        AppBootstrap.bootstrap(in: context)
        return container
    }()
}
