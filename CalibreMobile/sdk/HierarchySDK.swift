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
    
    var calibre: CalibreSDK?
    
    var fallback = FallbackSDK()
    
    var demo = DemoSDK()
    
    init() {

//        self.network = self.calibre.ping()
               
        
        
    }
    
    mutating func newServer(server: Server) {
        calibre = CalibreSDK(server: server)
    }
    
    func listLibs() async -> [String] {
        if hasAndSelectDemo {
            return await demo.listLibs()
        } else {
            return await calibre!.listLibs()
        }
    }
    
    func listBooks(by: String) async -> [Book] {
        if hasAndSelectDemo {
            return await demo.listBooks(by: by)
        } else {
            return await calibre!.listBooks(by: by)
        }
    }
}
