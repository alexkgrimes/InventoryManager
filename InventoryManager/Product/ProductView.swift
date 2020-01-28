//
//  ProductView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 1/26/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol ProductViewOutput {
    func addButtonTapped()
    func removeButtonTapped()
}

protocol ProductViewInput {
    func set(viewModel: ProductView.ViewModel)
}

class ProductView: UIView {
    
    private enum Constants {
        static let titleFontName = "Helvetica Neue"
        static let productNameTitle = "Product Name"
        static let quantityTitle = "Quantity"
        static let removeText = "REMOVE"
        static let addText = "ADD"
    }
    
    struct ViewModel {
        let productName: String?
        let quantity: String
        let addButtonColor: UIColor
        let removeButtonColor: UIColor
        
        static let empty = ViewModel(productName: "",
                                     quantity: String(1),
                                     addButtonColor: .lightGray,
                                     removeButtonColor: .lightGray)
    }
    
    var output: ProductViewController?
    var viewModel = ViewModel.empty
    
    // MARK: - Properties
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 32)
        label.text = Constants.productNameTitle
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 32)
        label.text = Constants.quantityTitle
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.removeText, for: .normal)
        button.backgroundColor = Color.lightBlue
        button.titleLabel?.textColor = Color.darkBlue
        button.layer.cornerRadius = CornerRadius.small
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.addText, for: .normal)
        button.titleLabel?.textColor = Color.darkBlue
        button.layer.cornerRadius = CornerRadius.small
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = Spacing.sixteen
        return stackView
    }()

    let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Spacing.sixteen
        return stackView
    }()
    
    
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hStack.addArrangedSubview(addButton)
        hStack.addArrangedSubview(removeButton)
        
        vStack.addArrangedSubview(title)
        vStack.addArrangedSubview(nameTextField)
        vStack.addArrangedSubview(quantityLabel)
        vStack.addArrangedSubview(quantityTextField)
        vStack.addArrangedSubview(hStack)
        
        addSubview(vStack)
        
        backgroundColor = Color.white
        
        setConstraints()
    }
}

private extension ProductView {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.twentyFour),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.twentyFour),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            vStack.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            quantityTextField.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor)
        ])
    }
    
    func apply(viewModel: ViewModel) {
        nameTextField.text = viewModel.productName
        quantityTextField.text = viewModel.quantity
        
        addButton.backgroundColor = viewModel.addButtonColor
        removeButton.backgroundColor = viewModel.removeButtonColor
    }
}

extension ProductView: ProductViewInput {
    
    func set(viewModel: ProductView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}

private extension ProductView {
    @objc func addButtonTapped() {
        output?.addButtonTapped()
    }
    
    @objc func removeButtonTapped() {
        output?.removeButtonTapped()
    }
}
