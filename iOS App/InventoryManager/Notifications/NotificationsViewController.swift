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
    
    var notifications: [Notification] = []
    
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

        view = NotificationsView()
        (view as? NotificationsView)?.output = self
        (view as? NotificationsView)?.set(viewModel: makeViewModel())
        
        navigationController?.navigationBar.tintColor = .lightGray
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        guard let uid = AuthController.userId else { return }
        DataController.notifications(for: uid, closure: dataDidUpdate(_:))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func makeViewModel() -> NotificationsView.ViewModel {
        let notificationViewModels = notifications.map { notification -> NotificationTableViewCell.ViewModel in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let dateString = dateFormatter.string(from: notification.dateTime! as Date)
            return NotificationTableViewCell.ViewModel(title: notification.title, message: notification.body, dateTime: dateString)
        }
        return NotificationsView.ViewModel(notifications: notificationViewModels)
    }
    
    func dataDidUpdate(_ notifications: [Notification]) {
        self.notifications = notifications
        didUpdate()
    }
}

private extension NotificationsViewController {
    func didUpdate() {
        (view as? NotificationsView)?.set(viewModel: makeViewModel())
    }
    
    func setBackBarButtonCustom() {
        //Back buttion
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backArrow"), for: UIControl.State())
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc func dismissViewController()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension NotificationsViewController: NotificationsViewOutput {
    
}
