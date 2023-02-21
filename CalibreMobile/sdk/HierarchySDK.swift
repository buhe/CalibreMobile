//
//  HierarchySDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/21.
//

import Foundation

struct HieratchySDK {
    var hasAndSelectDemo = false
    
    var network = false
    
    var calibre = CalibreSDK()
    
    var fallback = FallbackSDK()
    
    var demo = DemoSDK()
    
    func listLibs(server: Server) async -> [String] {
        if hasAndSelectDemo {
            return await demo.listLibs(server: server)
        } else {
            return await calibre.listLibs(server: server)
        }
    }
    
    func listBooks(by: String, server: Server) async -> [Book] {
        if hasAndSelectDemo {
            return await demo.listBooks(by: by, server: server)
        } else {
            return await calibre.listBooks(by: by, server: server)
        }
    }
}
