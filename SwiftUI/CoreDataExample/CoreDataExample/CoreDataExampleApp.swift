//
//  CoreDataExampleApp.swift
//  CoreDataExample
//
//  Created by jaewon Lee on 5/13/24.
//

import SwiftUI

@main
struct CoreDataExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
