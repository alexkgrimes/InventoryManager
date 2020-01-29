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
    var quantity: Int? = 1
    var addProduct = false
    var allFieldsSet: Bool {
        return (productName != "" && productName != nil) && (quantity != nil && quantity != 0)
    }
    
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
        let addButtonColor = addProduct ? Color.lightBlue : .lightGray
        let removeButtonColor = addProduct ? .lightGray : Color.lightBlue
        let confirmButtonColor = allFieldsSet ? Color.darkBlue : .lightGray
        
        let quantityString: String
        if let strongQuantity = quantity {
            quantityString = String(strongQuantity)
        } else {
            quantityString = ""
        }
        
        return ProductView.ViewModel(productName: productName,
                                     quantity: quantityString,
                                     addButtonColor: addButtonColor,
                                     removeButtonColor: removeButtonColor,
                                     confirmButtonColor: confirmButtonColor)
        
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
    
    func confirmButtonTapped() {
        // code
    }
    
    func nameTextFieldDidChange(with name: String) {
        productName = name
        didUpdate()
    }
    
    func quantityTextFieldDidChange(with quantity: String) {
        defer { didUpdate() }
        
        if quantity == "" {
            self.quantity = nil
        }
        
        guard let intQuantity = Int(quantity) else { return }
        self.quantity = intQuantity
    }
}

private extension ProductViewController {
    func didUpdate() {
        (view as? ProductView)?.set(viewModel: makeViewModel())
    }
}
