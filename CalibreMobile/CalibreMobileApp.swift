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
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 34)!]
    }
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel(viewContext: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
