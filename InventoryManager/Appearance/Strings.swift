//
//  Strings.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/14/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import Foundation

public enum ErrorStrings {
    static let invalidPassword = "Invalid Password"
    static let invalidPasswordMessage = "Please enter a password with at least 8 characters."
    
    static let invalidEmail = "Invalid Email"
    static let invalidEmailMessage = "Please enter a valid email."
    
    static let signInFailed = "Sign In Failed"
    static let signInFailedMessage = "Sorry, there has been an error signing in. Please re-try with your email and passowrd."
    
    static let createUserFailed = "Failed To Create User"
    static let createUserFailedMessage = "Sorry, there has been an error creating your account. Please recheck your network connection and try again later."
}

public enum Strings {
    static let ok = "OK"
}

public enum Regex {
    static let email = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    static let emailFormat = "SELF MATCHES[c] %@"
}
