//
//  BookView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI

struct BooksView: View {
    @State var books: [Book] = []
    @State var showCalibre = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                    ForEach(books) {
                        i in
                        BookView(book: i)
                    }
                    
                }
            }
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

struct BookView: View {
    let book: Book
    
    var body: some View {
        AsyncImage(url: URL(string: book.coverURL)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            // Placeholder view while the image is loading
            ProgressView()
        }
        .shadow(radius: 10)
        .frame(width: 120, height: 160)
        .aspectRatio(2/3, contentMode: .fit)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView()
    }
}
