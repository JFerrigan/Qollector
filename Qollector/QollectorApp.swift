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
        let schema = Schema(versionedSchema: QollectorSchemaV4.self)
        let primaryConfiguration = ModelConfiguration(
            "Qollector",
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: QollectorMigrationPlan.self,
                configurations: primaryConfiguration
            )
        } catch {
            // Recover from incompatible/corrupt local stores by creating a fresh store file.
            let recoveryConfiguration = ModelConfiguration(
                "QollectorRecovery",
                schema: schema,
                isStoredInMemoryOnly: false
            )

            do {
                return try ModelContainer(
                    for: schema,
                    migrationPlan: QollectorMigrationPlan.self,
                    configurations: recoveryConfiguration
                )
            } catch {
                fatalError("Unable to create model container (primary + recovery failed): \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
