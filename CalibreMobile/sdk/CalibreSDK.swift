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
        let reps = try? await AF.request("").serializingString().value
        print("call api.")
        if let reps = reps {
            let json = try? JSON(data: Data(reps.utf8))
            if let json = json {
                
            }
        }
        return [""]
    }
    
    func listBooks(by: String) async -> [Book] {
        [Book()]
    }
}
