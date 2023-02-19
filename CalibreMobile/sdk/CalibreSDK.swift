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
    
    func listLibs() async -> [String] {
        var result: [String] = []
        let reps = try? await AF.request("http://192.168.31.60:8080/interface-data/update").serializingString().value
        print("call api.")
        if let reps = reps {
            let json = try? JSON(data: Data(reps.utf8))
            if let json = json {
                result = Array(json["library_map"].dictionaryValue.keys)
            }
        }
        return result
    }
    
    func listBooks(by: String) async -> [Book] {
        
        var result: [Book] = []
        let reps = try? await AF.request("http://192.168.31.60:8080/interface-data/books-init?library_id=calibre&sort=timestamp.desc").serializingString().value
        print("call api.")
        if let reps = reps {
            let json = try? JSON(data: Data(reps.utf8))
            if let json = json {
                let metadata = json["metadata"].dictionaryValue
                result = metadata.map{
                    k,v in
                    Book(id: k,timestamp: v["timestamp"].stringValue, title: v["title"].stringValue, coverURL: "http://192.168.31.60:8080/get/thumb/\(k)/calibre?sz=600x800", formats: v["formats"].arrayObject as? [String], authors: v["authors"].arrayObject as? [String], tags: v["tags"].arrayObject as? [String], publisher: v["publisher"].stringValue, comments: v["comments"].string)
                }
            }
        }
        return result
    }
}
