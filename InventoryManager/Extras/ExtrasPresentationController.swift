//
//  ExtrasPresentationController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/9/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class ExtrasPresentationController: UIPresentationController {
    
    let blurEffectView: UIVisualEffectView
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var height: CGFloat?
    
    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        self.height = height
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: containerView!.frame.height/2),
                      size: CGSize(width: containerView!.frame.width, height: height ?? containerView!.frame.height/2))
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] UIViewControllerTransitionCoordinatorContext in
            self?.blurEffectView.alpha = 0
        }, completion: { [weak self] UIViewControllerTransitionCoordinatorContext in
            self?.blurEffectView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] UIViewControllerTransitionCoordinatorContext in
            self?.blurEffectView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in

        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.cornerRadius = 10
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}
