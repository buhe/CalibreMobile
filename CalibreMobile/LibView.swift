//
//  LibView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI

struct LibView: View {
    @State var selectedItem: String?
    @State var libs: [String] = []
    @State var showCalibre = false
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedItem)  {
                ForEach(libs, id: \.self) {
                    i in
                    HStack {
                        Image(systemName: "books.vertical")
                        Text(i)
                        
                    }
                    .padding(8)
                }.onChange(of: selectedItem ?? ""){
                    c in
                   print(selectedItem!)
                }
            }
            .listStyle(PlainListStyle())
            .task {
                self.libs =  await CalibreSDK().listLibs(server: viewModel.model.current!)
            }
            .onChange(of: viewModel.model.current) {
                s in
                Task {
                    self.libs =  await CalibreSDK().listLibs(server: viewModel.model.current!)
                }
                
            }
            .navigationTitle("Library")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{showCalibre = true}label: {
                        Image(systemName:"0.circle")
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
