//
//  NotificationsViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/23/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var appDisplayDelegate: AppDisplayDelegate
    
    // MARK: - View Lifecycle
    
    init(appDisplayDelegate: AppDisplayDelegate) {
        self.appDisplayDelegate = appDisplayDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        view = NotificationsView()
        (view as? NotificationsView)?.output = self
        (view as? NotificationsView)?.set(viewModel: makeViewModel())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func makeViewModel() -> NotificationsView.ViewModel {
        let notification = NotificationTableViewCell.ViewModel(title: "Boop boop title", message: "You got stuff with low stock!", dateTime: "dateTime")
        return NotificationsView.ViewModel(notifications: [notification])
    }
}

private extension NotificationsViewController {
    func didUpdate() {
        (view as? NotificationsView)?.set(viewModel: makeViewModel())
    }
}

extension NotificationsViewController: NotificationsViewOutput {
    
}
