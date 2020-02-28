//
//  Notification.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/27/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase

public struct Notification {
    let dateTime: NSDate?
    let title: String
    let body: String
    
    public init(dateTime: NSDate?, title: String, body: String) {
        self.dateTime = dateTime
        self.title = title
        self.body = body
    }
    
    init(snapshot: DataSnapshot) {
        if let t = TimeInterval(snapshot.key) {
            dateTime = NSDate(timeIntervalSince1970: t/1000)
        } else {
            dateTime = nil
        }
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        body = snapshotValue["body"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "message": body
        ]
    }
}
