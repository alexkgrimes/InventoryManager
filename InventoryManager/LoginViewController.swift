//
//  LoginViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 11/24/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private enum Constants {
        static let loginText = "Login"
        static let signUpText = "Sign Up"
    }
    
    // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Inventory Manager"
        label.font = UIFont(name: "Marker Felt", size: 100)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.loginText, for: .normal)
        button.backgroundColor = Color.brightBlue
        button.layer.cornerRadius = CornerRadius.small
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.signUpText, for: .normal)
        button.backgroundColor = Color.darkBlue
        button.layer.cornerRadius = CornerRadius.small
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

        loginView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(loginButton)
        hStack.addArrangedSubview(signUpButton)
        
        vStack.addArrangedSubview(usernameTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(hStack)
        
        loginView.addSubview(vStack)
        loginView.backgroundColor = Color.lightBlue
        loginView.layer.cornerRadius = CornerRadius.medium
        
        view.addSubview(label)
        view.addSubview(loginView)
        view.backgroundColor = .white
        
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
            usernameTextField.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor)
        ])
    }
}

