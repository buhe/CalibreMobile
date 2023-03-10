//
//  CablibreImage.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/21.
//

import SwiftUI

struct BookImage: View {
    let viewModel: ViewModel
    let book: Book
    var body: some View {
        if viewModel.model.sdk.hasAndSelectDemo {
            Image(book.id)
                .resizable()
        } else {
            if viewModel.model.sdk.network {
                AsyncImage(url: URL(string: book.coverURL)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    // Placeholder view while the image is loading
                    ProgressView()
                }
            } else {
                if let uiImage = UIImage(data: book.cover) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    ProgressView()
                }
            }
        }
    }
}

//struct CablibreImage_Previews: PreviewProvider {
//    static var previews: some View {
//        CablibreImage()
//    }
//}
