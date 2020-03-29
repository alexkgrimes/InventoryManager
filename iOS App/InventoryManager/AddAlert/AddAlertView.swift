//
//  AddAlertView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 3/1/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol AddAlertViewOutput {
    func pickerValueChanged(to: Int)
}

protocol AddAlertViewInput {
    func set(viewModel: AddAlertView.ViewModel)
}

class AddAlertView: UIView {

    private enum Constants {
        static let titleFontName = "Helvetica Neue"
        static let titleString = "Add an Alert"
        static let productString = "Assign to Product (Optional)"
        static let alertTypeString = "Select an Alert Type"
    }
    
    struct ViewModel {
        let pickerStrings: [String]
        let rowSelected: Int
        
        static let empty = ViewModel(pickerStrings: [], rowSelected: 0)
    }
    
    var output: AddAlertViewController?
    var viewModel = ViewModel.empty
    
    // MARK: - Properties
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 28)
        label.text = Constants.titleString
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alertTypeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 24)
        label.textAlignment = .left
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        label.text = Constants.alertTypeString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = Color.veryLightGray
        picker.layer.cornerRadius = CornerRadius.medium
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 24)
        label.textAlignment = .left
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        label.text = Constants.productString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productSearcher: SearchViewController = {
        let searcher = SearchViewController()
        return searcher
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
        
        productSearcher.willMove(toParent: output)
        
        vStack.addArrangedSubview(title)
        vStack.addArrangedSubview(alertTypeTitle)
        vStack.addArrangedSubview(picker)
        vStack.addArrangedSubview(productTitle)
        vStack.addArrangedSubview(productSearcher.searchBarController.textField)
        
        output?.addChild(productSearcher)
        productSearcher.didMove(toParent: output)
        
        addSubview(vStack)
        
        backgroundColor = .white
        self.picker.delegate = self
        self.picker.dataSource = self
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.twentyFour),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.twentyFour),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 80)
        ])
        
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: vStack.trailingAnchor)
        ])
    }
    
    func apply(viewModel: ViewModel) {
        picker.selectRow(viewModel.rowSelected, inComponent: 0, animated: true)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension AddAlertView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        output?.pickerValueChanged(to: row)
    }
}

extension AddAlertView: AddAlertViewInput {
    func set(viewModel: AddAlertView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}
