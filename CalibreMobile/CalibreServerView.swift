//
//  CalibreServerView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI

struct CalibreServerView: View {
    let viewModel: ViewModel
    let close: () -> Void
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var servers: FetchedResults<Server>
    
    @State var showNewServer = false
    @State var selectedItem: String?
    var body: some View {
        HStack {
            Spacer()
            Button{
                showNewServer = true
            }label:{
                Image(systemName: "plus")
            }.padding(.trailing)
            EditButton()
        }
        .sheet(isPresented: $showNewServer){
            NewServerView(firstServer: servers.isEmpty){
                showNewServer = false
            }
                .environment(\.managedObjectContext, viewContext)
        }
        .padding()
        List(selection: $selectedItem)  {
            ForEach(servers.map{ServerConfig(id: $0.name!, name: $0.name!, icon:
                                            $0.icon!, selected: $0.selected )}) {
                i in
                HStack {
//                    Image(systemName: i.selected ? "circle.fill" : "circle")
                    Image(systemName: i.selected ? i.icon + ".fill" : i.icon)
                    Text(i.name)
                }
            }.onDelete{
                sets in
                deleteItems(offsets: sets)
            }.onChange(of: selectedItem ?? ""){
                c in
                selectItem(id: c)
                close()
            }
        }
        .listStyle(PlainListStyle())
        
        
    }
    
       
    
    fileprivate func selectNext() {
        var allUnSelected = true
        for server in servers {
            if server.selected {
                allUnSelected = false
            }
        }
        if !servers.isEmpty && allUnSelected {
            let id = servers.first!.name!
            selectItem(id: id)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
            withAnimation {
                let delete = offsets.map { servers[$0] }
                delete.forEach{if $0.demo && $0.selected {
                    viewModel.model.hasAndSelectDemo = false
                    
                }}
//                delete.forEach{
//                    if $0.selected {
//                        viewModel.model.clearAll()
//                    }
//                }
                delete.forEach(viewContext.delete)
    
                do {
                    try viewContext.save()
                    selectNext()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    
    private func selectItem(id: String) {
        withAnimation {
            for cluster in servers {
                if cluster.name == id {
                    cluster.selected = true
                    if !cluster.demo {
                        viewModel.model.hasAndSelectDemo = false
                    }
                    
                } else {
                    cluster.selected = false
                }
            }

            do {
                try viewContext.save()
                viewModel.model.select(viewContext: viewContext)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private struct ServerConfig: Identifiable, Hashable {
    var id: String
    let name: String
    let icon: String
    let selected: Bool
}

struct CalibreServerView_Previews: PreviewProvider {
    static var previews: some View {
        CalibreServerView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext)){}
    }
}
