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

    override func viewDidLoad() {
        super.viewDidLoad()

        view = ProductView()
        (view as? ProductView)?.output = self
        (view as? ProductView)?.set(viewModel: makeViewModel())
    }
    
    func makeViewModel() -> ProductView.ViewModel {
        return ProductView.ViewModel(title: "This is it.")
    }
}

// MARK: - ProductViewOutput

extension ProductViewController: ProductViewOutput {
    
}
