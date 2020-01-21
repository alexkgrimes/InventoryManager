//
//  LoginViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 11/24/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit
import BarcodeScanner

protocol LoginViewControllerOutput {
    func signUpButtonTapped(email: String, password: String)
    func loginButtonTapped(email: String, password: String)
}

class LoginViewController: UIViewController {
    
    var output: LoginController?
    
    let codeDelegate = BarcodeDelegate(view: nil)
    
    private enum Constants {
        static let loginText = "Login"
        static let signUpText = "Sign Up"
        static let titleFontName = "Marker Felt"
        static let titleText = "Inventory Manager"
    }
    
    // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont(name: Constants.titleFontName, size: 100)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = Color.white
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .go
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.loginText, for: .normal)
        button.backgroundColor = Color.brightBlue
        button.layer.cornerRadius = CornerRadius.small
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.signUpText, for: .normal)
        button.backgroundColor = Color.darkBlue
        button.layer.cornerRadius = CornerRadius.small
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = Spacing.sixteen
        return stackView
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = Spacing.sixteen
        return stackView
    }()
    
    let loginView = UIView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = LoginController(view: self)

        loginView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(loginButton)
        hStack.addArrangedSubview(signUpButton)
        
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(hStack)
        
        loginView.addSubview(vStack)
        loginView.backgroundColor = Color.lightBlue
        loginView.layer.cornerRadius = CornerRadius.medium
        
        view.addSubview(label)
        view.addSubview(loginView)
        view.backgroundColor = Color.darkGray
        
        setConstraints()
    }
}

private extension LoginViewController {
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.sixteen),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.sixteen),
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            loginView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: loginView.topAnchor, constant: -Spacing.sixteen)
        ])
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: loginView.leadingAnchor, constant: Spacing.sixteen),
            vStack.trailingAnchor.constraint(equalTo: loginView.trailingAnchor, constant: -Spacing.sixteen),
            vStack.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -Spacing.sixteen),
            vStack.topAnchor.constraint(equalTo: loginView.topAnchor, constant: Spacing.sixteen)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor)
        ])
    }
}

extension LoginViewController {
    @objc func signUpButtonTapped() {
        view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        output?.signUpButtonTapped(email: email, password: password)
    }
    
    @objc func loginButtonTapped() {
        view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        output?.loginButtonTapped(email: email, password: password)
    }
}

extension LoginViewController: LoginControllerOutput {
    
    func presentPasswordNotValid() {
        let alert = UIAlertController(title: ErrorStrings.invalidPassword,
                                      message: ErrorStrings.invalidPasswordMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))

        present(alert, animated: true)
    }
    
    func presentEmailNotValid() {
        let alert = UIAlertController(title: ErrorStrings.invalidEmail,
                                      message: ErrorStrings.invalidEmailMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))

        present(alert, animated: true)
    }
    
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
        let barcodeScanner = BarcodeScannerViewController()
        codeDelegate.view = barcodeScanner
        barcodeScanner.codeDelegate = codeDelegate
        
        if let navigationController = navigationController {
            barcodeScanner.navigationController?.navigationBar.isHidden = false
            barcodeScanner.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: codeDelegate, action: #selector(codeDelegate.scannerDidLogout))
            barcodeScanner.navigationItem.hidesBackButton = true
            
            navigationController.pushViewController(barcodeScanner, animated: true)
            
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            
            navigationController.navigationBar.tintColor = Color.lightBlue
            
            navigationController.navigationBar.isHidden = false
        }
    }
}
