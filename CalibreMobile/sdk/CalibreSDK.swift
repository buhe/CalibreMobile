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
        [Book()]
    }
}
