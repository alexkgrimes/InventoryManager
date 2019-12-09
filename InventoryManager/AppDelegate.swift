//
//  AppDelegate.swift
//  InventoryManager
//
//  Created by Alex Grimes on 11/24/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit

public enum Spacing {
    static let four: CGFloat = 4
    static let eight: CGFloat = 8
    static let twelve: CGFloat = 12
    static let sixteen: CGFloat = 16
}

public enum Color {
    static let lightBlue = UIColor(red: 61.0 / 255.0, green: 118.0 / 255.0, blue: 210.0 / 255.0, alpha: 1)
    static let darkBlue = UIColor(red: 36.0 / 255.0, green: 71.0 / 255.0, blue: 144.0 / 255.0, alpha: 1)
    static let violet = UIColor(red: 92.0 / 255.0, green: 39.0 / 255.0, blue: 81.0 / 255.0, alpha: 1)
    static let lavender = UIColor(red: 157.0 / 255.0, green: 172.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
    static let brightBlue = UIColor(red: 118.0 / 255.0, green: 229.0 / 255.0, blue: 252.0 / 255.0, alpha: 1)
}

public enum CornerRadius {
    static let tiny: CGFloat = 3.0
    static let small: CGFloat = 6.0
    static let medium: CGFloat = 9.0
    static let large: CGFloat = 12.0
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//extension AppDelegate: BarcodeScannerCodeDelegate {
//    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
//        return
//    }
//}
//
//extension AppDelegate: BarcodeScannerErrorDelegate {
//    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
//        return
//    }
//}
//
//extension AppDelegate: BarcodeScannerDismissalDelegate {
//    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
//        return
//    }
//}
