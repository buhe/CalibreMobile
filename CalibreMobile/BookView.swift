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
                        AsyncImage(url: URL(string: "http://192.168.31.60:8080/get/thumb/27/calibre?sz=600x800")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            // Placeholder view while the image is loading
                            ProgressView()
                        }
                        .frame(width: 120, height: 160)
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
