//
//  DataController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 1/25/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase

final class DataController {
    static let rootRef = Database.database().reference()
    
    static let usersRef = Database.database().reference(withPath: "users")
    static let cacheRef = usersRef.child("cache")
    
    static func isUpcInCache(upc: String, found: @escaping (Product) -> Void, notFound: @escaping (String) -> Void) {
        rootRef.child("users/cache/\(upc)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let product = Product(snapshot: snapshot)
                found(product)
            } else{
                notFound(upc)
            }
        })
    }
    
    static func addProductToCache(product: Product) {
        let productRef = cacheRef.child(product.upc)
        productRef.setValue(product.toAnyObject())
    }
}
