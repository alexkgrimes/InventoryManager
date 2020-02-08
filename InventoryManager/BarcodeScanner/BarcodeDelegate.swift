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
        controller.resetWithError()
        
        // Check the firebase "cache"
        DataController.isUpcInCache(upc: code, found: found, notFound: notFound)
    }
    
    private func found(_ product: Product) {
        appDisplayDelegate?.routeToEnterProductView(with: product)
    }
    
    private func notFound(_ upc: String) {
        let search = "&upc=\(upc)"
        let urlString = Constants.baseURL + Constants.key + search
        guard let url = URL(string: urlString) else { return }

        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            
            guard error == nil, let data = data, let response = response as? HTTPURLResponse else {
                // TODO: Handle error, something went wrong
                return
            }
            
            guard response.statusCode == 200 else {
                DispatchQueue.main.async {
                    self?.appDisplayDelegate?.routeToEnterProductView(with: upc)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(ProductResponse.self, from: data)
                let product = response.product()
                DispatchQueue.main.async {
                    self?.appDisplayDelegate?.routeToEnterProductView(with: product)
                }
            } catch {
                // TODO: catch json decoder error
            }
        })

        task.resume()
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
