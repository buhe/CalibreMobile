//
//  CalibreMobileApp.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/18.
//

import SwiftUI

@main
struct CalibreMobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
