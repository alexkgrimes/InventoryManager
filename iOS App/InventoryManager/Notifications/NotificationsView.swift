//
//  NotificationsView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/23/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol NotificationsViewOutput {
    
}

protocol NotificationsViewInput {
    func set(viewModel: NotificationsView.ViewModel)
}

class NotificationsView: UIView {

    private enum Constants {
        static let titleFontName = "Helvetica Neue"
        static let title = "Notifications"
    }
    
    struct ViewModel {
        let notifications: [NotificationTableViewCell.ViewModel]
        
        static let empty = ViewModel(notifications: [])
    }
    
    var output: NotificationsViewOutput?
    var viewModel = ViewModel.empty
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.titleFontName, size: 28)
        label.text = Constants.title
        label.textAlignment = .left
        label.textColor = Color.darkBlue
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = NotificationsView.emptyString()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .singleLine
        table.backgroundColor = Color.white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "notificationCell")
        
        addSubview(titleLabel)
        addSubview(emptyLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.sixteen),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -160.0),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.twentyFour),
            emptyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.twentyFour)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func apply(viewModel: ViewModel) {
        if viewModel.notifications.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    static func emptyString() -> NSAttributedString {
        let titleString = NSMutableAttributedString(string: "No notifications.",
                                                            attributes: [NSAttributedString.Key.font: UIFont(name: Constants.titleFontName, size: 20), NSAttributedString.Key.foregroundColor: Color.darkBlue])
        let messageString = NSMutableAttributedString(string: "\nSet up an alert to start receiving notifications.",
                                                              attributes: [NSAttributedString.Key.font: UIFont(name: Constants.titleFontName, size: 20), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let combination = NSMutableAttributedString()
        
        combination.append(titleString)
        combination.append(messageString)
        return combination
    }
}

extension NotificationsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        cell.apply(viewModel: viewModel.notifications[indexPath.row])
        return cell
    }
}

extension NotificationsView: NotificationsViewInput {
    func set(viewModel: NotificationsView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}
