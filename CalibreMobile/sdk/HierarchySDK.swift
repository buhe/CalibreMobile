//
//  HierarchySDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/21.
//

import Foundation
import CoreData

class HieratchySDK {
    var hasAndSelectDemo = false
    
    var network = false
    
    var calibre: CalibreSDK?
    
    var fallback = FallbackSDK()
    
    var demo = DemoSDK()
    
    var timer: Timer?
    
    func newServer(server: Server, viewContext: NSManagedObjectContext) {
        calibre = CalibreSDK(server: server, viewContext: viewContext)
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
            return demo.listLibs()
        } else {
            if network {
                return await calibre!.listLibs()
            } else {
                return fallback.listLibs()
            }
        }
    }
    
    func listBooks(by: String) async -> [Book] {
        if hasAndSelectDemo {
            return demo.listBooks(by: by)
        } else {
            if network {
                return await calibre!.listBooks(by: by)
            } else {
                return fallback.listBooks(by: by)
            }
        }
    }
}
