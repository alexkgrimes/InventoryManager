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
    func dismiss()
}

protocol ExtrasViewInput {
    func set(viewModel: ExtrasView.ViewModel)
}

class ExtrasView: UIView {
    
    private enum Constants {
        static let rowHeight: CGFloat = 65.0
        static let headerHeight: CGFloat = 30.0
    }
    
    struct ViewModel {
        let actions: [String]
        let images: [UIImage?]
        
        static let empty = ViewModel(actions: [], images: [])
    }
    
    var output: ExtrasViewOutput?
    var viewModel = ViewModel.empty

    // MARK: - Properties
    
    let topView: ExtrasHeaderView = {
        let view = ExtrasHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = Color.white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExtraRowTableViewCell.self, forCellReuseIdentifier: "cell")	
        
        addSubview(topView)
        addSubview(tableView)
        setConstraints()
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
    
        let bottomInsets = safeAreaInsets.bottom
        let tableHeight = CGFloat(viewModel.actions.count) * Constants.rowHeight
        let padding = Constants.headerHeight + bottomInsets + Constants.rowHeight
        let modalHeight = tableHeight + padding
        frame = CGRect(origin: CGPoint(x: 0, y: superview!.frame.height - modalHeight),
                       size: CGSize(width: superview!.frame.width, height: modalHeight))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.rowTapped(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
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
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: Constants.headerHeight)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc func dismiss() {
        output?.dismiss()
    }
}
