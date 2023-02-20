//
//  DemoSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/20.
//

import Foundation

struct DemoSDK: SDK {
    func listLibs(server: Server) async -> [String] {
        []
    }
    
    func listBooks(by: String, server: Server) async -> [Book] {
        []
    }
    
    func ping() async -> Bool {
        false
    }
}
