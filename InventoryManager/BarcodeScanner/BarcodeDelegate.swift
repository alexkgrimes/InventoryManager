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
    
    private enum Constants {
        static let baseURL = "https://api.barcodespider.com/v1/lookup?token="
        static let key = "744d1b51d50d8a1bad4d"
        
    }
    
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
        
        // TODO: remove later, only for debugging
        print("type: \(type)")
        print("code: \(code)")
        
        // Check the firebase "cache"
        DataController.isUpcInCache(upc: code, found: found, notFound: notFound)
        
        // If in "cache" -> go ahead and add it (modal, just the quantity editable)
        
        // Else hit the api to find the item
        
            // if the api succeeds -> go ahead and add it (modal, just the quantity editable)
        
            // else -> present modal with sorry not found title (all fields editable)
        
        // ----------------------- hitting the API
        
//        let search = "&upc=\(code)"
//        let urlString = Constants.baseURL + Constants.key + search
//        guard let url = URL(string: urlString) else { return }
//        
//        let session = URLSession.shared
//        let task = session.dataTask(with: url, completionHandler: { data, response, error in
//            print("--- DATA ---")
//            print(data)
//            print("--- RESPONSE ---")
//            print(response)
//            print("--- ERROR ---")
//            print(error)
//            
//            // TODO: Handle error
//            if error != nil {
//                return
//            }
//        })
//        
//        task.resume()
       
    }
    
    private func found(_ product: Product) {
        appDisplayDelegate?.routeToEnterProductView(with: product)
    }
    
    private func notFound(_ upc: String) {
        appDisplayDelegate?.routeToEnterProductView(with: upc)
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
