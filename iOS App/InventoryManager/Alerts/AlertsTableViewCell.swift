//
//  AlertsTableViewCell.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/29/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class AlertsTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let alertTypeFont = "HelveticaNeue-Bold"
        static let productFont = "NelveticaNeue"
    }
    
    struct ViewModel {
        let alertTypeText: String
        let productText: String
        
        static let empty = ViewModel(alertTypeText: "", productText: "")
    }
    
    // MARK: - Properties
    
    let alertTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.alertTypeFont, size: 18)
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.productFont, size: 14)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = Spacing.four
        return stackView
    }()
    
    // MARK: - View Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        stackView.addArrangedSubview(alertTypeLabel)
        stackView.addArrangedSubview(productLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.sixteen),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.sixteen),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.sixteen),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.sixteen)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        alertTypeLabel.text = nil
        productLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func apply(viewModel: ViewModel) {
        alertTypeLabel.text = viewModel.alertTypeText
        productLabel.text = viewModel.productText
    }
}
