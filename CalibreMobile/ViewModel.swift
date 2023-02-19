//
//  ViewModel.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var model: Model
    
    init(model: Model) {
        self.model = model
    }
}
