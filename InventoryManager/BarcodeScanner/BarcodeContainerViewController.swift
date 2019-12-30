//
//  BarcodeContainerViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/28/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit
import BarcodeScanner

class BarcodeContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let barcodeScanner = BarcodeScannerViewController()
        view.addSubview(barcodeScanner.view)
        
        barcodeScanner.view.frame = view.bounds
        barcodeScanner.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        barcodeScanner.codeDelegate = self

        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.hidesBackButton = true
    }
    
    @objc func logoutTapped() {
        AuthController.signOut(output: self)
    }
}

extension BarcodeContainerViewController: AuthControllerLogout {
    func signOut() {
        navigationController?.popViewController(animated: true)
    }
}

extension BarcodeContainerViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        return
    }
}

extension BarcodeContainerViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        return
    }
}

extension BarcodeContainerViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        return
    }
}
