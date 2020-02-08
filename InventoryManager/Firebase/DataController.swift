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
    
    static func addInventory(for uid: String, product: Product, quantity: Int) {
        let inventoryRef = usersRef.child("\(uid)/\(product.upc)")
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
    
    static func removeInventory(for uid: String, product: Product, quantity: Int) {
        let inventoryRef = usersRef.child("\(uid)/\(product.upc)")
        inventoryRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                guard let currentQuantity = postDict["quantity"] as? Int else {
                    // TODO: you are adding to a product without quantity
                    return
                }
                let updatedQuantity = currentQuantity - quantity
                if updatedQuantity < 0 {
                    // TODO: oops something went wrong bc it says you have no inventory
                    return
                }
                inventoryRef.setValue(["name": product.name, "quantity": updatedQuantity])
            } else {
                // TODO: oops you never added this to your inventory, do you want to add now
            }
        })
    }
    
    static func addUser(with uid: String, email: String) {
        usersRef.child(uid).setValue(["email": email])
    }
}
