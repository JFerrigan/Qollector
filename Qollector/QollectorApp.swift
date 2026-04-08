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
        let schema = Schema([
            RecordItem.self,
            Tag.self,
            AppSettings.self,
        ])

        let modelConfiguration = ModelConfiguration(
            storeURL.lastPathComponent,
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            clearPersistentStore(at: storeURL)

            do {
                return try ModelContainer(for: schema, configurations: modelConfiguration)
            } catch {
                fatalError("Unable to create model container: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }

    private static var storeURL: URL {
        let applicationSupport = URL.applicationSupportDirectory
        let directory = applicationSupport.appending(path: "Qollector", directoryHint: .isDirectory)

        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory.appending(path: "Qollector.store")
    }

    private static func clearPersistentStore(at url: URL) {
        let fileManager = FileManager.default
        let relatedURLs = [
            url,
            url.appendingPathExtension("wal"),
            url.appendingPathExtension("shm")
        ]

        for relatedURL in relatedURLs where fileManager.fileExists(atPath: relatedURL.path) {
            try? fileManager.removeItem(at: relatedURL)
        }
    }
}
