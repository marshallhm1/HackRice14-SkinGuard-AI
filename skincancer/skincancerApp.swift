//
//  skincancerApp.swift
//  skincancer
//
//  Created by Andrew Arshia Almasi on 9/20/24.
//

import SwiftUI
import SwiftData

@main
struct skincancerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Report.self,
            WeeklyCheckIn.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
