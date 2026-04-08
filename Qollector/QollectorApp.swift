//
//  QollectorApp.swift
//  Qollector
//
//  Created by Jake Ferrigan on 4/7/26.
//

import Foundation
import SwiftData
import SwiftUI

@main
struct QollectorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: QollectorSchemaV3.self)

        let modelConfiguration = ModelConfiguration(
            "Qollector",
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: QollectorMigrationPlan.self,
                configurations: modelConfiguration
            )
        } catch {
            fatalError("Unable to create model container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
