//
//  BarcodeDelegate.swift
//  InventoryManager
//
//  Created by Alex Grimes on 12/28/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit
import BarcodeScanner

class BarcodeDelegate {
    
    var view: BarcodeScannerViewController?
    var appDisplayDelegate: AppDisplayDelegate?
    
    init(view: BarcodeScannerViewController?) {
        self.view = view
    }
    
    @objc func scannerDidLogout() {
        AuthController.signOut(output: self)
    }
}

extension BarcodeDelegate: AuthControllerLogout {
    func signOut() {
        appDisplayDelegate?.routeToLogIn()
    }
}

extension BarcodeDelegate: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        return
    }
}

extension BarcodeDelegate: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        return
    }
}

extension BarcodeDelegate: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        return
    }
}
