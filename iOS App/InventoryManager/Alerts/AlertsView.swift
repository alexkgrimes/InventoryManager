//
//  AlertsView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/29/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol AlertsViewOutput {
    
}

protocol AlertsViewInput {
    func set(viewModel: AlertsView.ViewModel)
}

class AlertsView: UIView {

    private enum Constants {
        static let titleFontName = "Helvetica Neue"
        static let title = "Alerts"
    }
    
    struct ViewModel {
        let alerts: [AlertsTableViewCell.ViewModel]
        
        static let empty = ViewModel(alerts: [])
    }
    
    var output: AlertsViewOutput?
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
        label.attributedText = AlertsView.emptyString()
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
        tableView.register(AlertsTableViewCell.self, forCellReuseIdentifier: "alertCell")
        
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
        if viewModel.alerts.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    static func emptyString() -> NSAttributedString {
        let titleString = NSMutableAttributedString(string: "No alerts.",
                                                    attributes: [NSAttributedString.Key.font: UIFont(name: Constants.titleFontName, size: 20)!, NSAttributedString.Key.foregroundColor: Color.darkBlue])
        let messageString = NSMutableAttributedString(string: "\nTap + to schedule an alert.",
                                                              attributes: [NSAttributedString.Key.font: UIFont(name: Constants.titleFontName, size: 20)! , NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let combination = NSMutableAttributedString()
        
        combination.append(titleString)
        combination.append(messageString)
        return combination
    }
}

extension AlertsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! AlertsTableViewCell
        cell.apply(viewModel: viewModel.alerts[indexPath.row])
        return cell
    }
}

extension AlertsView: AlertsViewInput {
    func set(viewModel: AlertsView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}
