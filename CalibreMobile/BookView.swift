//
//  BookView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI

struct BookView: View {
    @State var books: [Book] = []
    @State var showCalibre = false
    
    var body: some View {
        NavigationStack {
            List()  {
                ForEach(books) {
                    i in
                    HStack {
                        Image(systemName: "books.vertical")
                        Text(i.title)
                        
                    }
                    .padding(8)
                }
            }
            .listStyle(PlainListStyle())
            .task {
                self.books =  await CalibreSDK().listBooks(by: "")
            }
            .navigationTitle("Book")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{showCalibre = true}label: {
                        Image(systemName:"0.circle")
                    }
                }
            }
            .sheet(isPresented: $showCalibre){
                CalibreServerView()
            }
            
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
    }
}
