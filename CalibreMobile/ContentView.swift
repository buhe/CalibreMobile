//
//  ContentView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        TabView {
            BooksView(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Books", systemImage: "book")
            }
            
            LibView(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Library", systemImage: "books.vertical")
            }
            
            SettingView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                Label("Setting", systemImage: "gear")
            }
        }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
