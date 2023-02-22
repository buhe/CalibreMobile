//
//  FallbackSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/20.
//

import Foundation

/**
 - Use database when network loss.
 */

struct FallbackSDK {
    var book: CacheAction<BookCache, Book>
    
    init(book: CacheAction<BookCache, Book>) {
        self.book = book
        book.load()
    }
    
    func listLibs() -> [String] {
        []
    }
    
    func listBooks(by: String) -> [Book] {
        book.memory.sorted(by: {$0.id! > $1.id!}).map{
            cache in
            Book(id: cache.id ?? "", timestamp: cache.timestamp ?? "", title: cache.title ?? "", coverURL: "", formats: [], authors: [], tags: [], publisher: cache.publisher ?? "", comments: cache.comments ?? "", cover: cache.cover ?? Data())
        }
    }
    
}
