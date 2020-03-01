//
//  Alert.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/29/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase

public struct Alert {
    let alertType: AlertType
    let productUpc: String?
    
    public enum AlertType {
        case lowStock
        case outOfStock
        case unknown
    }
    
    public init(alertType: AlertType, productUpc: String?) {
        self.alertType = alertType
        self.productUpc = productUpc
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let isLowStock = snapshotValue["lowStock"] as! Bool
        let isOutOfStock = snapshotValue["outOfStock"] as! Bool
        
        if isLowStock {
            alertType = .lowStock
        } else if isOutOfStock {
            alertType = .outOfStock
        } else {
            alertType = .unknown
        }
        
        if let productUpc = snapshotValue["upc"] as? String {
            self.productUpc = productUpc
        } else {
            productUpc = nil
        }
    }
    
    func toAnyObject() -> Any {
        let isLowStock: Bool
        let isOutOfStock: Bool
        
        switch alertType {
        case .lowStock:
            isLowStock = true
            isOutOfStock = false
        case .outOfStock:
            isLowStock = false
            isOutOfStock = true
        case .unknown:
            isLowStock = false
            isOutOfStock = false
        }
        
        if let upc = productUpc {
            return [
                "lowStock": isLowStock,
                "outOfStock": isOutOfStock,
                "upc": upc
            ]
        }
        
        return [
            "lowStock": isLowStock,
            "outOfStock": isOutOfStock
        ]
    }
}
