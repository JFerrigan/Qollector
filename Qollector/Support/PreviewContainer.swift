import SwiftData

@MainActor
enum PreviewContainer {
    static let shared: ModelContainer = {
        let schema = Schema(versionedSchema: QollectorSchemaV3.self)

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: schema,
            migrationPlan: QollectorMigrationPlan.self,
            configurations: configuration
        )
        let context = container.mainContext

        AppBootstrap.bootstrap(in: context)
        return container
    }()
}
