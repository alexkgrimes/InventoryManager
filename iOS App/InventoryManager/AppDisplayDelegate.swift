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
    var productViewNavigationController: UINavigationController?
    var extrasNavigationController: UINavigationController?
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
        
        let rootViewController = LoginViewController(appDisplayDelegate: self)
        rootViewController.appDisplayDelegate = self
        navigationController?.setViewControllers([rootViewController], animated: false)
    }
    
    func routeToEnterProductView(with product: Product, currentQuantity: Int) {
        let productView = ProductViewController(appDisplayDelegate: self, product: product, currentQuantity: currentQuantity)
        productViewNavigationController = UINavigationController(rootViewController: productView)
        setUpProductView(productView)
        if let navigation = productViewNavigationController {
            navigationController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    func routeToEnterProductView(with upc: String) {
        let productView = ProductViewController(appDisplayDelegate: self, upc: upc)
        productViewNavigationController = UINavigationController(rootViewController: productView)
        setUpProductView(productView)
        if let navigation = productViewNavigationController {
            navigationController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    @objc func openExtrasModal() {
        let extrasView = ExtrasViewController(appDisplayDelegate: self)
        extrasNavigationController = UINavigationController(rootViewController: extrasView)
        extrasNavigationController?.navigationBar.isHidden = true
        if let navigation = extrasNavigationController {
             navigationController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    func routeToNotificationsView() {
        let notificationsView = NotificationsViewController(appDisplayDelegate: self)
        extrasNavigationController?.dismiss(animated: true) {
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.pushViewController(notificationsView, animated: true)
        }
    }
}

// MARK: - Error modals
extension AppDisplayDelegate {
    
    // Not currently used anywhere - want to try and have more descriptive errors
    func presentOopsSomethingWentWrong() {
        let alert = UIAlertController(title: ErrorStrings.oops, message: ErrorStrings.somethingWentWrong, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: nil))
        productViewNavigationController?.viewControllers.first?.present(alert, animated: true)
    }
    
    func presentNotSignedIn() {
        let alert = UIAlertController(title: ErrorStrings.oops, message: ErrorStrings.notSignedIn, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.signIn, style: .default, handler: { [weak self] action in
            self?.productViewNavigationController?.dismiss(animated: true, completion: { [weak self] in
                self?.routeToLogIn()
            })
        }))
        productViewNavigationController?.viewControllers.first?.present(alert, animated: true)
    }
    
    func presentConfirmLogout() {
        let alert = UIAlertController(title: Strings.areYouSureYouWantToLogOut,
                                      message: Strings.youWillHaveToEnterEmailAndPassword,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { action in
            AuthController.signOut(output: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        extrasNavigationController?.viewControllers.first?.present(alert, animated: true)
    }
    
    func presentAlertToast() {
        guard let window = UIApplication.shared.keyWindow else { return }
        Toast.show(message: "test message", window: window)
    }
}

extension AppDisplayDelegate: AuthControllerLogout {
    func signOut() {
        extrasNavigationController?.viewControllers.first?.dismiss(animated: true) {
            self.routeToLogIn()
        }
    }
}

// MARK: - Private

private extension AppDisplayDelegate {
    func setUpBarcodeScanner(_ barcodeScanner: BarcodeScannerViewController) {
        barcodeScanner.codeDelegate = codeDelegate
        codeDelegate.view = barcodeScanner
        codeDelegate.appDisplayDelegate = self
        
        setUpBarButtonItem(for: barcodeScanner)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = Color.lightBlue
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func setUpBarButtonItem(for barcodeScanner: BarcodeScannerViewController) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "3lines"), for: .normal)
        button.addTarget(self, action: "openExtrasModal", for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        barcodeScanner.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        barcodeScanner.navigationItem.hidesBackButton = true
    }
    
    func setUpProductView(_ productView: ProductViewController) {
        productView.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "✕", style: .plain, target: productView, action: #selector(productView.didDismiss))
    }
}
