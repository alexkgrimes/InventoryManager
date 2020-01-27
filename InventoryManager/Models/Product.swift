//
//  Product.swift
//  InventoryManager
//
//  Created by Alex Grimes on 1/25/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase

public struct Product: Codable {
    let upc: String
    let name: String
    
    public init(upc: String, name: String) {
        self.upc = upc
        self.name = name
    }
    
    init(snapshot: DataSnapshot) {
        upc = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}
