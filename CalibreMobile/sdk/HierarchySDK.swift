//
//  HierarchySDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/21.
//

import Foundation

class HieratchySDK {
    var hasAndSelectDemo = false
    
    var network = false
    
    var calibre: CalibreSDK?
    
    var fallback = FallbackSDK()
    
    var demo = DemoSDK()
    
    var timer: Timer?
    
    func newServer(server: Server) {
        calibre = CalibreSDK(server: server)
        if timer != nil {
            timer?.invalidate()
        }
        if !hasAndSelectDemo {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {
                _ in
                print("ping!")
                do {
                    try self.calibre!.ping()
                    self.network = true
                } catch{
                    self.network = false
                }
                
            })
        }
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
