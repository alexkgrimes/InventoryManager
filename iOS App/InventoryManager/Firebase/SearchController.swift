//
//  SearchController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 3/8/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase
import InstantSearch

final class SearchController {
    static func search() {
        let client = Client(appID: "ERY7OGMDGD", apiKey: "")
        let index = client.index(withName: "products")
    }

}
