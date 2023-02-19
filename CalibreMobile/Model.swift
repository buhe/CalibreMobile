//
//  Model.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import Foundation

struct Book: Identifiable {
    let id: String
    let formats: [String]?
    let authors: [String]?
    let tags: [String]?
    let publisher: String?
    let comments: String?
    let timestamp: String
    let title: String
}

struct Model {
    var lib: String = ""
}
