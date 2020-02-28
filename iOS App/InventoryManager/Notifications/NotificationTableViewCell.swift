//
//  NotificationTableViewCell.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/25/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let titleFontName = "HelveticaNeue-Bold"
        static let bodyFontName = "HelveticaNeue"
    }
    
    struct ViewModel {
        let title: String
        let message: String
        let dateTime: String
        
        static let empty = ViewModel(title: "",
                                     message: "",
                                     dateTime: "")
    }
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 18)
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.bodyFontName, size: 16)
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.bodyFontName, size: 14)
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
    
    // MARK: - View LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
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
        titleLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func apply(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message
        dateLabel.text = viewModel.dateTime
    }

}
