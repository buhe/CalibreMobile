//
//  ViewModel.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import Foundation
import CoreData

class ViewModel: ObservableObject {
    
    @Published var model: Model
    
    init(viewContext: NSManagedObjectContext) {
        model = Model(viewContext: viewContext)
            
    }
}
