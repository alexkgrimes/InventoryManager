//
//  ProductViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 1/26/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    var appDisplayDelegate: AppDisplayDelegate?
    
    var productName: String?
    var quantity = 1
    var addProduct = false
    
    // MARK: - View Lifecycle
    
    init(productName: String? = nil) {
        self.productName = productName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = ProductView()
        (view as? ProductView)?.output = self
        didUpdate()
    }
    
    func makeViewModel() -> ProductView.ViewModel {
        if addProduct {
            return ProductView.ViewModel(productName: productName, quantity: String(quantity), addButtonColor: Color.lightBlue, removeButtonColor: .lightGray)
        } else {
            return ProductView.ViewModel(productName: productName, quantity: String(quantity), addButtonColor: .lightGray, removeButtonColor: Color.lightBlue)
        }
        
    }
    
    @objc func didDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProductViewOutput

extension ProductViewController: ProductViewOutput {
    func addButtonTapped() {
        if addProduct {
            return
        } else {
            addProduct = true
        }
        didUpdate()
    }
    
    func removeButtonTapped() {
        if addProduct {
            addProduct = false
        } else {
            return
        }
        didUpdate()
    }
}

private extension ProductViewController {
    func didUpdate() {
        (view as? ProductView)?.set(viewModel: makeViewModel())
    }
}
