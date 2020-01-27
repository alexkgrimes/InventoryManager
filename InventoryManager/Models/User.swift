//
//  User.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/9/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import Foundation

public struct User: Codable {
    let name: String
    let email: String

    public init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
