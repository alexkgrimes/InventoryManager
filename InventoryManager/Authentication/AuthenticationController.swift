//
//  AuthenticationController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/9/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import Foundation
import CryptoKit

final class AuthController {
    
    static let serviceName = "InventoryManagerService"
    
    static var isSignedIn: Bool {
        guard let currentUser = Settings.currentUser else {
            return false
        }
        
        do {
            let password = try KeychainPasswordItem(service: serviceName, account: currentUser.email).readPassword()
            return password.count > 0
        } catch {
            return false
        }
    }
    
    class func passwordHash(from email: String, password: String) -> SHA256Digest {
        let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
        let inputString = "\(password).\(email).\(salt)"
        let inputData = Data(inputString.utf8)
        return SHA256.hash(data: inputData)
    }
    
    class func signIn(_ user: User, password: String) throws {
        let finalHash = passwordHash(from: user.email, password: password)
        let hashString = finalHash.compactMap { String(format: "%02x", $0) }.joined()
        try KeychainPasswordItem(service: serviceName, account: user.email).savePassword(hashString)

        Settings.currentUser = user
    }
}
