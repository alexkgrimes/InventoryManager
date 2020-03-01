//
//  AlertsViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/29/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {
    
    let appDisplayDelegate: AppDisplayDelegate
    
    var alerts: [Alert] = []

    init(appDisplayDelegate: AppDisplayDelegate) {
        self.appDisplayDelegate = appDisplayDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = AlertsView()
        (view as? AlertsView)?.output = self
        (view as? AlertsView)?.set(viewModel: makeViewModel())

        navigationController?.navigationBar.tintColor = .lightGray
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let button: UIButton = UIButton(frame: .zero)
        button.titleLabel?.text = "＋"
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: "addAlert", for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func addAlert() {
        print("add alert tapped")
    }
    
    func makeViewModel() -> AlertsView.ViewModel {
        return AlertsView.ViewModel(alerts: [AlertsTableViewCell.ViewModel(alertTypeText: "Low Stock Alert Type", productText: "For Melatonin 3mg")])
    }

    func dataDidUpdate(_ alerts: [Alert]) {
        self.alerts = alerts
        didUpdate()
    }
}

private extension AlertsViewController {
    func didUpdate() {
        (view as? AlertsView)?.set(viewModel: makeViewModel())
    }
}

extension AlertsViewController: AlertsViewOutput {
    
}
