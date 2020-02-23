//
//  ExtrasHeaderView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/10/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class ExtrasHeaderView: UIView {

    // MARK: - Properties
    
    let barImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "dragBar")
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        backgroundColor = .white
        
        addSubview(barImageView)
        NSLayoutConstraint.activate([
            barImageView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.four),
            barImageView.widthAnchor.constraint(equalToConstant: 50),
            barImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            barImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

}
