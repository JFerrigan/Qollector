//
//  VinylCollectorApp.swift
//  VinylCollector
//
//  Created by Jake Ferrigan on 4/7/26.
//

import SwiftData
import SwiftUI

@main
struct VinylCollectorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecordItem.self,
            Tag.self,
            AppSettings.self,
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
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
