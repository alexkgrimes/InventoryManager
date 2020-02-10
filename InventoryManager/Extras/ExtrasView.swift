//
//  ExtrasView.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/9/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol ExtrasViewOutput {
    func rowTapped(at index: Int)
}

protocol ExtrasViewInput {
    func set(viewModel: ExtrasView.ViewModel)
}

class ExtrasView: UIView {
    
    private enum Constants {
        static let rowHeight: CGFloat = 65.0
    }
    
    struct ViewModel {
        let actions: [String]
        let images: [UIImage?]
        
        static let empty = ViewModel(actions: [], images: [])
    }
    
    var output: ExtrasViewOutput?
    var viewModel = ViewModel.empty

    // MARK: - Properties
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine
        table.backgroundColor = Color.white
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExtraRowTableViewCell.self, forCellReuseIdentifier: "cell")
        
        addSubview(tableView)
        setConstraints()
    }
}

// MARK: - TableView Delegate, DataSource

extension ExtrasView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExtraRowTableViewCell
        cell.apply(title: viewModel.actions[indexPath.row], image: viewModel.images[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

// MARK: - ExtrasViewInput

extension ExtrasView: ExtrasViewInput {
    func set(viewModel: ExtrasView.ViewModel) {
        self.viewModel = viewModel
        apply(viewModel: viewModel)
    }
}

// MARK: - Private

private extension ExtrasView {
    func apply(viewModel: ViewModel) {
        tableView.reloadData()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
