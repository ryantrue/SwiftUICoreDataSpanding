//
//  SwiftUICoreDataSpandingTrackerApp.swift
//  SwiftUICoreDataSpandingTracker
//
//  Created by Ryan on 3/9/22.
//

import SwiftUI

@main
struct SwiftUICoreDataSpandingTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
