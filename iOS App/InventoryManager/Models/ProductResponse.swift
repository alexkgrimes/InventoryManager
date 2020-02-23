//
//  ProductResponse.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/8/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation

struct ProductResponse: Decodable {
    let itemResponse: ItemResponse
    let itemAttributes: ItemAttributes
    
    func product() -> Product {
        return Product(upc: itemAttributes.upc, name: itemAttributes.title)
    }
}

struct ItemResponse: Decodable {
    let code: Int
    let status: String
    let message: String
}

struct ItemAttributes: Decodable {
    let title: String
    let upc: String
    let brand: String
}
