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
    func confirmButtonTapped()
    func nameTextFieldDidChange(with name: String)
    func quantityTextFieldDidChange(with quantity: String)
}

protocol ProductViewInput {
    func set(viewModel: ProductView.ViewModel)
}

class ProductView: UIView {
    
    private enum Constants {
        static let titleFontName = "Helvetica Neue"
        static let productNameTitle = "Product Name"
        static let quantityTitle = "Quantity"
        static let currentText = "\t Currently: "
        static let removeText = "REMOVE"
        static let addText = "ADD"
        static let confirmText = "CONFIRM"
    }
    
    struct ViewModel {
        let productName: String?
        let quantity: String
        let currentQuantity: String
        let addButtonColor: UIColor
        let removeButtonColor: UIColor
        let confirmButtonColor: UIColor
        
        static let empty = ViewModel(productName: "",
                                     quantity: String(1),
                                     currentQuantity: String(0),
                                     addButtonColor: .lightGray,
                                     removeButtonColor: .lightGray,
                                     confirmButtonColor: .lightGray)
    }
    
    var output: ProductViewController?
    var viewModel = ViewModel.empty
    
    // MARK: - Properties
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 28)
        label.text = Constants.productNameTitle
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20)
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
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.confirmText, for: .normal)
        button.titleLabel?.textColor = Color.darkBlue
        button.layer.cornerRadius = CornerRadius.small
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
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
        addSubview(confirmButton)
        
        backgroundColor = Color.white
        
        nameTextField.delegate = self
        quantityTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        quantityTextField.addTarget(self, action: #selector(quantityTextFieldDidChange), for: .editingChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
        
        
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
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.twentyFour),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.twentyFour),
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.twentyFour),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
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
        quantityLabel.attributedText = quantityString(currentQuantity: viewModel.currentQuantity)
        
        addButton.backgroundColor = viewModel.addButtonColor
        removeButton.backgroundColor = viewModel.removeButtonColor
        
        confirmButton.backgroundColor = viewModel.confirmButtonColor
    }
}

extension ProductView: ProductViewInput {
    
    func set(viewModel: ProductView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}

extension ProductView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension ProductView {
    
    @objc func addButtonTapped() {
        output?.addButtonTapped()
    }
    
    @objc func removeButtonTapped() {
        output?.removeButtonTapped()
    }
    
    @objc func confirmButtonTapped() {
        output?.confirmButtonTapped()
    }
    
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        output?.nameTextFieldDidChange(with: text)
    }
    
    @objc func quantityTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        output?.quantityTextFieldDidChange(with: text)
    }
    
    func quantityString(currentQuantity: String) -> NSAttributedString {
        let quantityTitleString = NSMutableAttributedString(string: Constants.quantityTitle,
                                                            attributes: [NSAttributedString.Key.font: UIFont(name: Constants.titleFontName, size: 28)!, NSAttributedString.Key.foregroundColor: Color.darkBlue])
        let currentQuantityString = NSMutableAttributedString(string: "\(Constants.currentText) \(currentQuantity)",
                                                              attributes: [NSAttributedString.Key.font: UIFont(name: Constants.titleFontName, size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let combination = NSMutableAttributedString()
        
        combination.append(quantityTitleString)
        combination.append(currentQuantityString)
        return combination

    }
}
