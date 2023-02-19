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
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedItem)  {
                ForEach(libs, id: \.self) {
                    i in
                    HStack {
                        Image(systemName: "books.vertical")
                        Text(i)
                        
                    }
                }.onChange(of: selectedItem ?? ""){
                    c in
                   print(selectedItem!)
                }
            }
            .listStyle(PlainListStyle())
            .task {
                self.libs =  await CalibreSDK().listLibs()
            }
            .navigationTitle("Library")
            
        }
        
    }
}

struct LibView_Previews: PreviewProvider {
    static var previews: some View {
        LibView()
    }
}
