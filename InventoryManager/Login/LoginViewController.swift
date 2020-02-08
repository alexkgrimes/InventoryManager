//
//  LoginViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/9/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var appDisplayDelegate: AppDisplayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = LoginView()
        (view as? LoginView)?.output = self
    }
}

// MARK: - LoginViewOutput

extension LoginViewController: LoginViewOutput {
    func signUpButtonTapped(email: String, password: String) {
        if !emailIsValid(email) {
            presentEmailNotValid()
        }
        
        if password.count < 8 {
            presentPasswordNotValid()
        }
        
        AuthController.signUp(output: self, email, password: password)
    }
    
    func loginButtonTapped(email: String, password: String) {
        if !emailIsValid(email) {
            presentEmailNotValid()
        }
        
        if password.count < 8 {
            presentPasswordNotValid()
        }
        
        AuthController.signIn(output: self, email, password: password)
    }
}

// MARK: - AuthControllerOutput

extension LoginViewController: AuthControllerOutput {
    
    func signInFailed() {
        let alert = UIAlertController(title: ErrorStrings.signInFailed,
                                      message: ErrorStrings.signInFailedMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))
        
        self.present(alert, animated: true)
    }
    
    func createUserFailed() {
        let alert = UIAlertController(title: ErrorStrings.createUserFailed,
                                      message: ErrorStrings.createUserFailedMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))
        
        self.present(alert, animated: true)
    }
    
    func signInSuccess() {
        appDisplayDelegate?.routeToBarcodeScanner()
    }
}

// MARK: - Private

private extension LoginViewController {
    
    func emailIsValid(_ email: String) -> Bool {
        let emailRegEx = Regex.email
        let emailTest = NSPredicate(format: Regex.emailFormat, emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func presentEmailNotValid() {
        let alert = UIAlertController(title: ErrorStrings.invalidEmail,
                                      message: ErrorStrings.invalidEmailMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))

        present(alert, animated: true)
    }
    
    func presentPasswordNotValid() {
        let alert = UIAlertController(title: ErrorStrings.invalidPassword,
                                      message: ErrorStrings.invalidPasswordMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))

        present(alert, animated: true)
    }
}
