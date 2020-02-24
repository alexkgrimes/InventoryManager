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
    
    static func isUpcInCache(upc: String, found: @escaping (Product, Int) -> Void, notFound: @escaping (String) -> Void) {
        rootRef.child("users/cache/\(upc)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                notFound(upc)
                return
            }
            
            let product = Product(snapshot: snapshot)
            guard let uid = AuthController.userId else { return }
            
            rootRef.child("users/\(uid)/products/\(upc)").observeSingleEvent(of: .value, with: { snapshot1 in
                guard snapshot1.exists() else {
                    found(product, 0)
                    return
                }
                
                let postDict = snapshot1.value as? [String : AnyObject] ?? [:]
                if let currentQuantity = postDict["quantity"] as? Int {
                    found(product, currentQuantity)
                } else {
                    found(product, 0)
                }
            })
        })
    }
    
    static func addProductToCache(product: Product) {
        let productRef = cacheRef.child(product.upc)
        productRef.setValue(product.toAnyObject())
    }
    
    static func addInventory(for uid: String, product: Product, quantity: Int) {
        let inventoryRef = usersRef.child("\(uid)/products/\(product.upc)")
        inventoryRef.observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                inventoryRef.setValue(["name": product.name, "quantity": quantity])
                return
            }
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            guard let currentQuantity = postDict["quantity"] as? Int else {
                // TODO: error handling here
                return
            }
            let updatedQuantity = currentQuantity + quantity
            inventoryRef.setValue(["name": product.name, "quantity": updatedQuantity])
        })
    }
    
    static func removeInventory(for uid: String, product: Product, quantity: Int) {
        let inventoryRef = usersRef.child("\(uid)/products/\(product.upc)")
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
        let emailRef = usersRef.child("\(uid)/email")
        emailRef.setValue(email)
    }
    
    static func updateRemoteInstanceID(with notificationToken: String) {
        guard let userId = AuthController.userId else { return }
        let notificationTokenRef = usersRef.child("\(userId)/notificationTokens")
        notificationTokenRef.setValue([notificationToken: ""])

    }
}
