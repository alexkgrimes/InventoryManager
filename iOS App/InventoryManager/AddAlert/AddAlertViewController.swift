//
//  AddAlertViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 3/1/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class AddAlertViewController: UIViewController {
    
    var appDisplayDelegate: AppDisplayDelegate
    
    var alertTypeStrings: [String] = Alert.AlertType.allCases.map { $0.rawValue }
    var currentlySelectedAlertType: String = ""
    
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

        view.backgroundColor = .white
        view = AddAlertView()
        (view as? AddAlertView)?.output = self
        didUpdate()
    }
    

    @objc func didDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func makeViewModel() -> AddAlertView.ViewModel {
        let rowIndex = alertTypeStrings.firstIndex(of: currentlySelectedAlertType) ?? 0
        return AddAlertView.ViewModel(pickerStrings: alertTypeStrings, rowSelected: rowIndex)
    }
}

private extension AddAlertViewController {
    func didUpdate() {
        (view as? AddAlertView)?.set(viewModel: makeViewModel())
    }
}

extension AddAlertViewController: AddAlertViewOutput {
    func pickerValueChanged(to row: Int) {
        currentlySelectedAlertType = alertTypeStrings[row]
    }
}
