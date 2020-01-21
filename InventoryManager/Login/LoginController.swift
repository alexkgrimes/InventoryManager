//
//  LoginController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/9/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit

protocol LoginControllerOutput {
    func presentEmailNotValid()
    func presentPasswordNotValid()
    func signInFailed()
    func createUserFailed()
    func signInSuccess()
}

class LoginController {
    var view: LoginControllerOutput
    var appDisplayDelegate: AppDisplayDelegate?
    
    init(view: LoginViewController) {
        self.view = view
    }
}

extension LoginController: LoginViewControllerOutput {
    func signUpButtonTapped(email: String, password: String) {
        if !emailIsValid(email) {
            view.presentEmailNotValid()
        }
        
        if password.count < 8 {
            view.presentPasswordNotValid()
        }
        
        let name = UIDevice.current.name
        let user = User(name: name, email: email)
        
        AuthController.signUp(output: self, user, password: password)
    }
    
    func loginButtonTapped(email: String, password: String) {
        if !emailIsValid(email) {
            view.presentEmailNotValid()
        }
        
        if password.count < 8 {
            view.presentPasswordNotValid()
        }
        
        let name = UIDevice.current.name
        let user = User(name: name, email: email)
        AuthController.signIn(output: self, user, password: password)
    }
}

extension LoginController: AuthControllerOutput {
    
    func signInFailed() {
        view.signInFailed()
    }
    
    func signInSuccess() {
        view.signInSuccess()
    }
    
    func createUserFailed() {
        view.createUserFailed()
    }
}

private extension LoginController {
    
    func emailIsValid(_ email: String) -> Bool {
        let emailRegEx = Regex.email
        let emailTest = NSPredicate(format: Regex.emailFormat, emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
