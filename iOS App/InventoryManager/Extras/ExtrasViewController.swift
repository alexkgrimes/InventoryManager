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
        static let notifications = "Notifications"
        
        static let rowHeight: CGFloat = 65.0
        static let placeholderImage = UIImage(named: "actionFiller")
        static let alertImage = UIImage(named: "alert")
        static let notificationImage = UIImage(named: "notification")
        static let reportImage = UIImage(named: "report")
        static let profileImage = UIImage(named: "profile")
        static let passwordImage = UIImage(named: "password")
        static let logoutImage = UIImage(named: "logout")
    }
    
    private enum ExtraRow: Int {
        case viewProfile = 2
        case requestAReport = 3
        case changePassword = 4
        case logOut = 5
        case setUpAlerts = 0
        case notification = 1
    }
    
    var appDisplayDelegate: AppDisplayDelegate
    
    var titles = [Constants.setUpAlerts,
                  Constants.notifications,
                  Constants.requestAReport,
                  Constants.viewProfile,
                  Constants.changePassword,
                  Constants.logout]
    var images = [Constants.alertImage,
                  Constants.notificationImage,
                  Constants.reportImage,
                  Constants.profileImage,
                  Constants.passwordImage,
                  Constants.logoutImage]
    
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
        let row = ExtraRow(rawValue: index)
        switch row {
        case .setUpAlerts:
            handleSetUpAlerts()
        case .requestAReport:
            handleRequestAReport()
        case .viewProfile:
            handleViewProfile()
        case .changePassword:
            handleChangePassword()
        case .logOut:
            handleLogOut()
        case .notification:
            handleNotification()
        default:
            return
        }
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension ExtrasViewController {
    func handleSetUpAlerts() {
        appDisplayDelegate.routeToAlertsView()
    }
    
    func handleRequestAReport() {
        
    }
    
    func handleViewProfile() {
        
    }
    
    func handleChangePassword() {
        
    }
    
    func handleNotification() {
        appDisplayDelegate.routeToNotificationsView()
    }
    
    func handleLogOut() {
        appDisplayDelegate.presentConfirmLogout()
    }
    
    func makeViewModel() -> ExtrasView.ViewModel {
        return ExtrasView.ViewModel(actions: titles, images: images)
    }
}

extension ExtrasViewController: AuthControllerLogout {
    func signOut() {
        appDisplayDelegate.routeToLogIn()
    }
}
