//
//  LoginView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 11/24/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit
import BarcodeScanner

protocol LoginViewOutput {
    func signUpButtonTapped(email: String, password: String)
    func loginButtonTapped(email: String, password: String)
}

class LoginView: UIView {
    
    var output: LoginViewController?
    
    private enum Constants {
        static let loginText = "Login"
        static let signUpText = "Sign Up"
        static let titleFontName = "Marker Felt"
        static let titleText = "Inventory Manager"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        
        static let titleFontSize: CGFloat = 100
        static let textfieldFontSize: CGFloat = 15
    }
    
    // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont(name: Constants.titleFontName, size: Constants.titleFontSize)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = Color.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.emailPlaceholder
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
        textField.placeholder = Constants.passwordPlaceholder
        textField.font = UIFont.systemFont(ofSize: Constants.textfieldFontSize)
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
    
    let loginView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.lightBlue
        view.layer.cornerRadius = CornerRadius.medium
        return view
    }()
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()

        hStack.addArrangedSubview(loginButton)
        hStack.addArrangedSubview(signUpButton)
        
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(hStack)
        
        loginView.addSubview(vStack)
        
        addSubview(label)
        addSubview(loginView)
        backgroundColor = Color.darkGray
        
        setConstraints()
    }
}

// MARK: - Private

private extension LoginView {
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.sixteen),
            loginView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.sixteen),
            loginView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            loginView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.twentyFour),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.twentyFour),
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

extension LoginView {
    @objc func signUpButtonTapped() {
        endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        output?.signUpButtonTapped(email: email, password: password)
    }
    
    @objc func loginButtonTapped() {
        endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        output?.loginButtonTapped(email: email, password: password)
    }
}
