//
//  CalibreSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

struct PingError: Error {
    
}
struct CalibreSDK {
    let server: Server
    let viewContext: NSManagedObjectContext
    var book: CacheAction<BookCache, Book>
    
    func ping() throws {
        var e: Any? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "http://\(server.host!):\(server.port!)/interface-data/update")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            e = error
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        if e != nil {
            throw PingError()
        }
    }
    
    
    func listLibs() async -> [String] {
        var result: [String] = []
        if server.demo {
            return result
        }
        let reps = try? await AF.request("http://\(server.host!):\(server.port!)/interface-data/update").serializingString().value
        print("call api.")
        if let reps = reps {
            let json = try? JSON(data: Data(reps.utf8))
            if let json = json {
                let libs = json["library_map"].dictionaryValue
                result = Array(libs.sorted(by: {a,b in (a.key.compare(b.key)).rawValue < 0}).map{k,v in k})
//                addLib(libs: result)
            }
        }
        return result
    }
    
    private func addLib(libs: [String]) {
        for lib in libs {
            let l = LibCache(context: viewContext)
            l.name = lib
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func listBooks(by: String) async -> [Book] {
        
        var result: [Book] = []
        if server.demo {
            return result
        }
        print("by \(by)")
        let reps = try? await AF.request("http://\(server.host!):\(server.port!)/interface-data/books-init?library_id=\(by)&sort=timestamp.desc").serializingString().value
        print("call api.")
        if let reps = reps {
            let json = try? JSON(data: Data(reps.utf8))
            if let json = json {
                let metadata = json["metadata"].dictionaryValue
                result = metadata.sorted(by: {a,b in (a.key.compare(b.key)).rawValue > 0}).map{
                    k,v in
                    Book(id: k,timestamp: v["timestamp"].stringValue, title: v["title"].stringValue, coverURL: "http://\(server.host!):\(server.port!)/get/thumb/\(k)/calibre?sz=600x800", formats: v["formats"].arrayObject as? [String], authors: v["authors"].arrayObject as? [String], tags: v["tags"].arrayObject as? [String], publisher: v["publisher"].stringValue, comments: v["comments"].string, cover: Data())
                }
                await book.fill(rest: result, add: addBook, remove: removeBook,transfer: transferBook)
            }
        }
        return result
    }
    
    private func transferBook(books: [BookCache]) -> [String] {
        books.map{$0.id!}
    }
    
    private func removeBook(ids: Set<String>) {
        // 创建 NSFetchRequest 对象，设置查询条件
        for id in ids {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookCache")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            // 获取需要删除的记录
            guard let records = try? viewContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return
            }

            // 删除记录
            for record in records {
                viewContext.delete(record)
            }
        }
        

        // 保存更改
        

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addBook(books: [Book]) async {
        for book in books {
            let b = BookCache(context: viewContext)
            b.id = book.id
            b.title = book.title
            b.coverURL = book.coverURL
            b.authors = JSON(book.authors ?? []).rawString()
            b.publisher = book.publisher
            b.comments = book.comments
            b.formats = JSON(book.formats ?? []).rawString()
            b.tags = JSON(book.tags ?? []).rawString()
            b.timestamp = book.timestamp
            let datas = await AF.request(book.coverURL).serializingData().response
            b.cover = datas.data
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
