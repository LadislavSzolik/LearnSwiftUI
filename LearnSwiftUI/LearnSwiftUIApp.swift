//
//  LearnSwiftUIApp.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 05.01.23.
//

import SwiftUI

@main
struct LearnSwiftUIApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
