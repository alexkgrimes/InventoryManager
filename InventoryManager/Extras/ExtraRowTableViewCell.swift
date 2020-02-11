//
//  ExtraRowTableViewCell.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/9/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class ExtraRowTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let fontName = "Helvetica Neue"
    }
    
    // MARK: - Properties
    
    let cellImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(cellImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        titleLabel.text = nil
        cellImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func apply(title: String, image: UIImage?) {
        titleLabel.text = title
        cellImageView.image = image
    }
}

// MARK: - Private

private extension ExtraRowTableViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.eight),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.eight),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.eight),
            cellImageView.widthAnchor.constraint(equalTo: heightAnchor, constant: -Spacing.sixteen)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: Spacing.sixteen),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.eight),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.eight),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.eight)
        ])
    }
}
