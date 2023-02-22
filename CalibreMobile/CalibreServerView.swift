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
    @State var showHelp = false
    
    var body: some View {
        HStack {
            Button {
                showHelp = true
            }label: {
                Image(systemName: "questionmark.circle")
            }
            Spacer()
            Button{
                showNewServer = true
            }label:{
                Image(systemName: "plus")
            }.padding(.trailing)
            EditButton()
        }
        .sheet(isPresented: $showNewServer){
            NewServerView(firstServer: servers.isEmpty, viewModel: viewModel){
                c in
                selectItem(id: c)
                showNewServer = false
                close()
            }
                .environment(\.managedObjectContext, viewContext)
        }
        .padding()
        .sheet(isPresented: $showHelp){
            CalibreHelpView()
        }
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
                    viewModel.model.sdk.hasAndSelectDemo = false
                    
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
                        viewModel.model.sdk.hasAndSelectDemo = false
                    }
                    
                } else {
                    cluster.selected = false
                }
            }

            do {
                try viewContext.save()
                viewModel.model.select(viewContext: viewContext)
                
                Task {
                    let libs = await viewModel.model.sdk.listLibs()
                    if !libs.isEmpty {
                        viewModel.model.lib = libs.first!
                    }
                }
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

struct CalibreHelpView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("How do I use calibre with my iPad/iPhone/iPod touch?")
                .font(.title)
                .padding(.vertical)
            Text("""
                An easy way to browse your calibre collection from your Apple device is by using The calibre Content server, which makes your collection available over the net. First perform the following steps in calibre

                Set the Preferred Output Format in calibre to EPUB (The output format can be set under Preferences → Interface → Behavior)

                Set the output profile to iPad (this will work for iPhone/iPods as well), under Preferences → Conversion → Common options → Page setup

                Convert the books you want to read on your iDevice to EPUB format by selecting them and clicking the Convert button.

                Turn on the Content server by clicking the Connect/share button and leave calibre running. You can also tell calibre to automatically start the Content server via Preferences → Sharing → Sharing over the net.

                The Content server allows you to read books directly in Safari itself. In addition, there are many apps for your iDevice that can connect to the calibre Content server.
                """)
            Text("Using the Content server with this app")
                .font(.title)
                .padding(.vertical)
            Text("""
                Click the plus button, enter the correct IP and port of the content server.
                
                Click the Test button to ensure that the IP and port are correct, and then click the Save button.
                """)
            Spacer()
        }
        .padding()
        
        
    }
}

struct CalibreServerView_Previews: PreviewProvider {
    static var previews: some View {
        CalibreServerView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext)){}
    }
}
