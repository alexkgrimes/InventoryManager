//
//  LoginController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/9/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit

protocol LoginControllerOutput {
    
}

class LoginController {
    var view: LoginViewController
    
    init(view: LoginViewController) {
        self.view = view
    }
}

extension LoginController: LoginViewControllerOutput {
    func signUpButtonTapped(email: String, password: String) {
        if !emailIsValid(email) {
            // show not email not valid modal
        }
        
        if password.count < 8 {
            // show password not long enough modal
        }
        
        let name = UIDevice.current.name
        let user = User(name: name, email: email)
        
        do {
          try AuthController.signIn(user, password: password)
        } catch {
          print("Error signing in: \(error.localizedDescription)")
        }
    }
}

private extension LoginController {
    
    func emailIsValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
