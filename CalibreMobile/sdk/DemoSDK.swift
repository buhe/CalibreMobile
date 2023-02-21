//
//  DemoSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/20.
//

import Foundation

struct DemoSDK {
    func listLibs(server: Server) async -> [String] {
        ["demo1", "demo2"]
    }
    
    func listBooks(by: String, server: Server) async -> [Book] {
        [Book(id: "1", timestamp: "2023", title: "Demo1", coverURL: "1", formats: [], authors: ["author1"], tags: [], publisher: "publisher1", comments: "comments1"), Book(id: "2", timestamp: "2023", title: "Demo2", coverURL: "2", formats: [], authors: ["author2"], tags: [], publisher: "publisher2", comments: "comments2"), Book(id: "3", timestamp: "2023", title: "Demo3", coverURL: "3", formats: [], authors: ["author3"], tags: [], publisher: "publisher3", comments: "comments3")]
    }
    
}
