//
//  CacneAction.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/22.
//

import Foundation
import CoreData

class CacheAction<T, R: Identifiable> {
    var memory: [T] = []
    let viewContext: NSManagedObjectContext
    let key: String
    
    var loadCache = true
    
    init(viewContext: NSManagedObjectContext, key: String) {
        self.viewContext = viewContext
        self.key = key
    }
    
    func fill(rest: [R], add: (_ items: [R]) async -> Void, remove: (_ items: Set<String>) -> Void, transfer: (_ items: [T]) -> [String]) async {
        if loadCache {
            memory = try! viewContext.fetch(NSFetchRequest(entityName: key)) as! [T]
            loadCache.toggle()
        }
        // memory and ids diff
        let mid = transfer(memory)
        let rid = rest.map{$0.id as! String}
        let a = Set(rid).subtracting(Set(mid))
        print("add: \(a)")
        let r = Set(mid).subtracting(Set(rid))
        print("remove: \(r)")
        var addItems: [R] = []
        // find rest by a
        if !a.isEmpty {
            addItems = rest.filter{a.contains($0.id as! String)}
        }

        let diffIds = !a.isEmpty || !r.isEmpty
        if diffIds {
            loadCache.toggle()
            // change db
            // remove
            remove(r)
            // add
            await add(addItems)
        }
    }
    
    func load() {
        memory = try! viewContext.fetch(NSFetchRequest(entityName: key)) as! [T]
    }
}
