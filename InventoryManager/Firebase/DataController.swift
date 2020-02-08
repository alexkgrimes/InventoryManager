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
            } else {
                notFound(upc)
            }
        })
    }
    
    static func addProductToCache(product: Product) {
        let productRef = cacheRef.child(product.upc)
        productRef.setValue(product.toAnyObject())
    }
    
    static func addInventory(for user: User, product: Product, quantity: Int) {
        guard let userId = AuthController.userId else {
            return
        }
        
        let inventoryRef = usersRef.child("\(userId)/\(product.upc)")
        inventoryRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                guard let currentQuantity = postDict["quantity"] as? Int else {
                    // TODO: error handling here
                    return
                }
                let updatedQuantity = currentQuantity + quantity
                inventoryRef.setValue(["name": product.name, "quantity": updatedQuantity])
            } else {
                inventoryRef.setValue(["name": product.name, "quantity": quantity])
            }
        })
    }
    
    static func removeInventory(for user: User, product: Product, inventory: Int) {
        
    }
    
    static func addUser(with uid: String, email: String) {
        usersRef.child(uid).setValue(["email": email])
    }
}
