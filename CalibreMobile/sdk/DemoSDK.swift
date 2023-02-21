//
//  DemoSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/20.
//

import Foundation

struct DemoSDK {
    func listLibs() -> [String] {
        ["demo1", "demo2"]
    }
    
    func listBooks(by: String) -> [Book] {
        [Book(id: "1", timestamp: "2023", title: "Demo1", coverURL: "1", formats: [], authors: ["author1"], tags: [], publisher: "publisher1", comments: "comments1"), Book(id: "2", timestamp: "2023", title: "Demo2", coverURL: "2", formats: [], authors: ["author2"], tags: [], publisher: "publisher2", comments: "comments2"), Book(id: "3", timestamp: "2023", title: "Demo3", coverURL: "3", formats: [], authors: ["author3"], tags: [], publisher: "publisher3", comments: "comments3"), Book(id: "4", timestamp: "2023", title: "Demo4", coverURL: "4", formats: [], authors: ["author1"], tags: [], publisher: "publisher4", comments: "comments4"), Book(id: "5", timestamp: "2023", title: "Demo5", coverURL: "5", formats: [], authors: ["author5"], tags: [], publisher: "publisher5", comments: "comments5")]
    }
    
}
