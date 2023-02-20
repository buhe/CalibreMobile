//
//  CalibreSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import Foundation
import Alamofire
import SwiftyJSON

struct CalibreSDK {
    
    func listLibs(server: Server) async -> [String] {
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
            }
        }
        return result
    }
    
    func listBooks(by: String, server: Server) async -> [Book] {
        
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
                result = metadata.sorted(by: {a,b in (a.key.compare(b.key)).rawValue < 0}).map{
                    k,v in
                    Book(id: k,timestamp: v["timestamp"].stringValue, title: v["title"].stringValue, coverURL: "http://192.168.31.60:8080/get/thumb/\(k)/calibre?sz=600x800", formats: v["formats"].arrayObject as? [String], authors: v["authors"].arrayObject as? [String], tags: v["tags"].arrayObject as? [String], publisher: v["publisher"].stringValue, comments: v["comments"].string)
                }
            }
        }
        return result
    }
}
