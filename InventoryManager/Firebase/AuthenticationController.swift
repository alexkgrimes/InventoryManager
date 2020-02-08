//
//  AuthenticationController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/9/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import Foundation
import CryptoKit
import FirebaseAuth
import Firebase

protocol AuthControllerOutput {
    func signInFailed()
    func signInSuccess()
    func createUserFailed()
}

protocol AuthControllerLogout {
    func signOut()
}

final class AuthController {
    
    static let serviceName = "InventoryManagerService"
    
    static var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static func signIn(output: AuthControllerOutput, _ user: User, password: String) {
        Auth.auth().signIn(withEmail: user.email, password: password) { authUser, signInError in
            if signInError != nil, authUser == nil {
                output.signInFailed()
            } else {
                output.signInSuccess()
            }
        }
    }
    
    static func signUp(output: AuthControllerOutput, _ user: User, password: String) {
        Auth.auth().createUser(withEmail: user.email, password: password) { authUser, createError in
            guard let uid = authUser?.user.uid, createError == nil else {
                output.createUserFailed()
                return
            }
            
            DataController.addUser(with: uid, email: user.email)
            
            Auth.auth().signIn(withEmail: user.email, password: password) { user, signInError in
                if signInError != nil, user == nil {
                    output.signInFailed()
                } else {
                    output.signInSuccess()
                }
            }
        }
    }
    
    static func signOut(output: AuthControllerLogout) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        onlineRef.removeValue { error, _ in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
        }
        
        do {
            try Auth.auth().signOut()
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        
        output.signOut()
    }
}
