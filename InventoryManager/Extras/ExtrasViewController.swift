//
//  ExtrasViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 2/9/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class ExtrasViewController: UIViewController {
    
    private enum Constants {
        static let viewProfile = "View Profile"
        static let requestAReport = "Request a Report"
        static let changePassword = "Change Password"
        static let logout = "Log Out"
        static let setUpAlerts = "Set Up Alerts"
        
        static let rowHeight: CGFloat = 65.0
        static let placeholderImage = UIImage(named: "actionFiller")
    }
    
    private enum ExtraRow {
        case viewProfile
        case requestAReport
        case changePassword
        case logOut
        case setUpAlerts
        case unknown
    }
    
    var appDisplayDelegate: AppDisplayDelegate
    
    var titles = [Constants.setUpAlerts,
                  Constants.requestAReport,
                  Constants.viewProfile,
                  Constants.changePassword,
                  Constants.logout]
    var images = [Constants.placeholderImage,
                  Constants.placeholderImage,
                  Constants.placeholderImage,
                  Constants.placeholderImage,
                  Constants.placeholderImage]
    
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
        view = ExtrasView()
        (view as? ExtrasView)?.output = self
        (view as? ExtrasView)?.set(viewModel: makeViewModel())
    }
}

// MARK: - ExtrasViewOutput

extension ExtrasViewController: ExtrasViewOutput {
    func rowTapped(at index: Int) {
        let row: ExtraRow
        switch index {
            case 0: row = .setUpAlerts
            case 1: row = .requestAReport
            case 2: row = .viewProfile
            case 3: row = .changePassword
            case 4: row = .logOut
            default: row = .unknown
        }
        
        handleRowTapped(with: row)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension ExtrasViewController {
    private func handleRowTapped(with row: ExtraRow) {
        // TODO: handle this correctly
        print(row)
    }
    
    func makeViewModel() -> ExtrasView.ViewModel {
        return ExtrasView.ViewModel(actions: titles, images: images)
    }
}
