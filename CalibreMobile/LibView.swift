//
//  LibView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI

struct LibView: View {
    @State var libs: [String] = []
    @State var showCalibre = false
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var servers: FetchedResults<Server>
    
    var body: some View {
        NavigationStack {
            List(selection: $viewModel.model.lib)  {
                ForEach(libs, id: \.self) {
                    i in
                    HStack {
                        Image(systemName: "books.vertical")
                        Text(i)
                        
                    }
                    .padding(8)
                }
            }
            .listStyle(PlainListStyle())
            .task {
                self.libs =  await viewModel.model.sdk.listLibs()
            }
            .onChange(of: viewModel.model.current) {
                s in
                Task {
                    self.libs =  await viewModel.model.sdk.listLibs()
                    if !libs.isEmpty {
                        viewModel.model.lib = libs.first!
                    }
                }
                
            }
            .navigationTitle("Library")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    HStack{
                        Button{showCalibre = true}label: {
                            Image(systemName: servers.filter{$0.selected}.first?.icon! ?? "0.circle")
                        }
                        Image(systemName: "alarm.waves.left.and.right")
                            .foregroundColor(.red)
                            .opacity(0.7)
                    }
                }
            }
            .sheet(isPresented: $showCalibre){
                CalibreServerView(viewModel: viewModel){
                    showCalibre = false
                }
            }
            
        }
        
    }
}

struct LibView_Previews: PreviewProvider {
    static var previews: some View {
        LibView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
