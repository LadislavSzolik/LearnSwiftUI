//
//  LearnSwiftUIApp.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 05.01.23.
//

import SwiftUI

@main
struct LearnSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
