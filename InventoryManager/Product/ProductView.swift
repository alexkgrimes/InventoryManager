//
//  ProductView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 1/26/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol ProductViewOutput {
    // code
}

protocol ProductViewInput {
    func set(viewModel: ProductView.ViewModel)
}

class ProductView: UIView {
    
    private enum Constants {
        static let titleFontName = "Helvetica Neue"
    }
    
    struct ViewModel {
        let title: String
        
        static let empty = ViewModel(title: "")
    }
    
    var output: ProductViewController?
    var viewModel = ViewModel.empty
    
    // MARK: - Properties
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 100)
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(title)
        
        backgroundColor = Color.white
        
        setConstraints()
    }
}

private extension ProductView {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            title.topAnchor.constraint(equalTo: topAnchor, constant: -Spacing.sixteen)
        ])
    }
    
    func apply(viewModel: ViewModel) {
        title.text = viewModel.title
    }
}

extension ProductView: ProductViewInput {
    
    func set(viewModel: ProductView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}
