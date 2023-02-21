//
//  CalibreMobileApp.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/18.
//

import SwiftUI
import Combine


@main
struct CalibreMobileApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 34)!]
    }
    var body: some Scene {
        let timerWrapper = TimerWrapper()
        timerWrapper.start()
        return WindowGroup {
            ContentView(viewModel: ViewModel(viewContext: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerWrapper)
        }
    }
}


class TimerWrapper : ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    var timer : Timer!
    func start(withTimeInterval interval: Double = 0.5) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.objectWillChange.send()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
    }
}
