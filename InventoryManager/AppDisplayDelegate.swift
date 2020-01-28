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
        codeDelegate.appDisplayDelegate = self
    }
    
    func appStartUp() {
        
        if AuthController.isSignedIn {
            let barcodeScanner = BarcodeScannerViewController()
            navigationController?.setViewControllers([barcodeScanner], animated: true)
            setUpBarcodeScanner(barcodeScanner)
        } else {
            routeToLogIn()
        }
    }
    
    func routeToBarcodeScanner() {
        let barcodeScanner = BarcodeScannerViewController()
        setUpBarcodeScanner(barcodeScanner)
        navigationController?.pushViewController(barcodeScanner, animated: true)
    }
    
    func routeToLogIn() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.popToRootViewController(animated: false)
        
        let rootViewController = LoginViewController()
        rootViewController.appDisplayDelegate = self
        navigationController?.setViewControllers([rootViewController], animated: false)
    }
    
    func routeToEnterProductView(with product: Product) {
        let productView = ProductViewController()
        setUpProductView(productView)
        navigationController?.present(productView, animated: true, completion: nil)
    }
    
    func routeToEnterProductView(with upc: String) {
        let productView = ProductViewController()
        let productViewNavigation: UINavigationController = UINavigationController(rootViewController: productView)
        setUpProductView(productView)
        navigationController?.present(productViewNavigation, animated: true, completion: nil)
    }
}

// MARK: - Private

private extension AppDisplayDelegate {
    func setUpBarcodeScanner(_ barcodeScanner: BarcodeScannerViewController) {
        barcodeScanner.codeDelegate = codeDelegate
        codeDelegate.view = barcodeScanner
        codeDelegate.appDisplayDelegate = self
        
        navigationController?.navigationBar.isHidden = false
        barcodeScanner.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: codeDelegate, action: #selector(codeDelegate.scannerDidLogout))
        barcodeScanner.navigationItem.hidesBackButton = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = Color.lightBlue
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func setUpProductView(_ productView: ProductViewController) {
        productView.appDisplayDelegate = self
        productView.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "✕", style: .plain, target: productView, action: #selector(productView.didDismiss))
    }
}
