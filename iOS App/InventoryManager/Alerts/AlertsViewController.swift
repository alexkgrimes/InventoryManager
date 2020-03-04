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
    
    private enum Constants {
        static let titleFontName = "Helvetica Neue"
    }

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
        dataDidUpdate([Alert(alertType: .lowStock, productUpc: nil)])

        setUpNavigationBarButtonItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func addAlert() {
        appDisplayDelegate.presentAddAlert()
    }
    
    func makeViewModel() -> AlertsView.ViewModel {
        let alertViewModels = alerts.map { alert -> AlertsTableViewCell.ViewModel in
            let alertTypeText = alert.alertType == .lowStock ? "Low Stock Alert" : "Out of Stock Alert"
            return AlertsTableViewCell.ViewModel(alertTypeText: alertTypeText, productText: "product text")
        }
        return AlertsView.ViewModel(alerts: alertViewModels)
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
    
    func setUpNavigationBarButtonItems() {
        navigationController?.navigationBar.tintColor = .lightGray
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let button: UIButton = UIButton(type: .system)
        button.setTitle("＋", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.titleFontName, size: 36)
        button.addTarget(self, action: "addAlert", for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}

extension AlertsViewController: AlertsViewOutput {
    
}
