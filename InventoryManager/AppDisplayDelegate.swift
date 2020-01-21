//
//  AppDisplayDelegate.swift
//  InventoryManager
//
//  Created by Alex Grimes on 1/20/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit
import BarcodeScanner

class AppDisplayDelegate {
    
    let navigationController: UINavigationController?
    let codeDelegate = BarcodeDelegate(view: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func appStartUp() {
        let rootViewController = LoginViewController()
        rootViewController.appDisplayDelegate = self
        navigationController?.setViewControllers([rootViewController], animated: true)
        
        if AuthController.isSignedIn {
            let barcodeScanner = BarcodeScannerViewController()
            barcodeScanner.codeDelegate = codeDelegate
            codeDelegate.view = barcodeScanner
            
            barcodeScanner.navigationController?.navigationBar.isHidden = false
            barcodeScanner.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: codeDelegate, action: #selector(codeDelegate.scannerDidLogout))
            barcodeScanner.navigationItem.hidesBackButton = true
            
            navigationController?.pushViewController(barcodeScanner, animated: true)
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            
            navigationController?.navigationBar.tintColor = Color.lightBlue
            
            navigationController?.navigationBar.isHidden = false
        } else {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    func routeToBarcodeScanner() {
        let barcodeScanner = BarcodeScannerViewController()
        codeDelegate.view = barcodeScanner
        barcodeScanner.codeDelegate = codeDelegate
        
        barcodeScanner.navigationController?.navigationBar.isHidden = false
        barcodeScanner.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: codeDelegate, action: #selector(codeDelegate.scannerDidLogout))
        barcodeScanner.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(barcodeScanner, animated: true)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = Color.lightBlue
        
        navigationController?.navigationBar.isHidden = false
    }
}
