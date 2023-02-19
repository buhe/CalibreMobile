//
//  BookDetailView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI
import WebKit

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: book.coverURL)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        // Placeholder view while the image is loading
                        ProgressView()
                    }
                    .shadow(radius: 10)
                    .frame(width: 240, height: 320)
                    //                Text(book.title)
                    //                    .font(.title)
                    ForEach(book.authors ?? [], id: \.self){
                        au in
                        Text("-- \(au)")
                    }
                    Text(book.publisher ?? "")
                    //                Text(book.comments ?? "")
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
        BookDetailView(book: Book(id: "1", timestamp: "2023", title: "1234567890qwertyuiopkjhgfdsazxcvbnm,.1234567890-][poiiuytrreewwqqasdfghjkl;'/.,mnbvcxcz", coverURL: "http://192.168.31.60:8080/get/thumb/1/calibre?sz=600x800", formats: [],authors: ["abc"],tags: [],publisher: "123",comments: "1234567890abcdf"))
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
