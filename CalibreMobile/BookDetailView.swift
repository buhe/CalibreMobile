//
//  BookDetailView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI
import WebKit

struct BookDetailView: View {
    let viewModel: ViewModel
    let book: Book
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    BookImage(viewModel: viewModel, book: book)
                    .shadow(radius: 10)
                    .frame(width: 240, height: 320)
                    
                    ForEach(book.authors ?? [], id: \.self){
                        au in
                        Text("-- \(au)")
                    }
                    Text(book.publisher ?? "")
                    HTMLView(htmlString: book.comments ?? "")
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    
                    
                }
                .padding()
            }
            .navigationTitle(book.title)
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext), book: Book(id: "1", timestamp: "2023", title: "1234567890qwertyuiopkjhgfdsazxcvbnm,.1234567890-][poiiuytrreewwqqasdfghjkl;'/.,mnbvcxcz", coverURL: "http://192.168.31.60:8080/get/thumb/1/calibre?sz=600x800", formats: [],authors: ["abc"],tags: [],publisher: "123",comments: "1234567890abcdf", cover: Data()))
    }
}

struct HTMLView: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}
