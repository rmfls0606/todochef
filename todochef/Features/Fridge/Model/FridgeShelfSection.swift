//
//  FridgeShelfSection.swift
//  todochef
//
//  Created by 이상민 on 11/17/26.
//

import Foundation

struct FridgeShelfSection: Identifiable{
    let shelf: Shelf
    let tasks: [Task]
    
    var id: Shelf{
        shelf
    }
}
