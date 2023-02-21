//
//  Model.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import Foundation
import SwiftUI
import CoreData

struct Book: Identifiable {
    let id: String
    let timestamp: String
    let title: String
    let coverURL: String
    let formats: [String]?
    let authors: [String]?
    let tags: [String]?
    let publisher: String?
    let comments: String?

}

struct Model {
    @AppStorage(wrappedValue: true, "first") var first: Bool
    private var viewContext: NSManagedObjectContext
    var current: Server? {
        didSet {
            print("Monitor sever: \(self.current!)")
            // ping new server
            self.sdk.newServer(server: self.current!, viewContext: viewContext)
        }
    }
    
    @AppStorage("libs") var lib: String?

    var sdk = HieratchySDK()
    fileprivate func workaroundChinaSpecialBug() {
        let url = URL(string: "https://www.baidu.com")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let _ = data else { return }
//            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    fileprivate func selectNotSome(c: Server) -> (Bool) {
        return (c != self.current)
    }
    
    fileprivate func addDemo(_ viewContext: NSManagedObjectContext, _ clusters: inout [Server]) {
        let newItem = Server(context: viewContext)
        newItem.name = "demo"
        newItem.icon = "d.circle"
        
        newItem.selected = true
        newItem.demo = true
        
        clusters.append(newItem)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    mutating func select(viewContext: NSManagedObjectContext) {
        var clusters = try! viewContext.fetch(NSFetchRequest(entityName: "Server")) as! [Server]
        if clusters.isEmpty {
            addDemo(viewContext, &clusters)
        }
        for c in clusters {
            if c.selected {
                print("found cluster: \(c)")
                if c.demo {
                    print("has demo")
                    sdk.hasAndSelectDemo = true
                }
                
                if !selectNotSome(c: c) {
                    break
                }
                
                self.current = c
            }
        }
    }

    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        if first {
            workaroundChinaSpecialBug()
            first = false
        }
        
        select(viewContext: viewContext)
    }
}
