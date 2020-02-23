//
//  Toast.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/18/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class Toast {
    
    static func show(message: String, window: UIWindow) {
        let toastHeight: CGFloat = 64.0
        let toastContainer = UIView(frame: CGRect(x: window.frame.origin.x,
                                                  y: -toastHeight,
                                                  width: window.frame.width,
                                                  height: toastHeight))
        toastContainer.backgroundColor = .white
        toastContainer.layer.cornerRadius = 10
        toastContainer.clipsToBounds = false
        
        let toastLabel = UILabel(frame: .zero)
        toastLabel.textColor = Color.darkBlue
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        window.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: Spacing.eight),
            toastContainer.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -Spacing.eight),
            toastContainer.topAnchor.constraint(equalTo: window.topAnchor, constant: -toastHeight),
            toastContainer.heightAnchor.constraint(equalToConstant: toastHeight)
        ])
        
        toastContainer.dropShadow(scale: true)
        animate(toastView: toastContainer)
    }
    
    static func animate(toastView: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            toastView.transform = toastView.transform
                .translatedBy(x: 0, y: toastView.frame.height + Spacing.sixteen)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0, animations: {
                toastView.transform = CGAffineTransform.identity
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        })
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = .zero
        layer.shadowRadius = 5.0
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
