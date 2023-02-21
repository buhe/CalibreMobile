//
//  FallbackSDK.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/20.
//

import Foundation

/**
 - Use database when network loss.
 */

struct FallbackSDK {
    func listLibs() -> [String] {
        []
    }
    
    func listBooks(by: String) -> [Book] {
        []
    }
    
}
