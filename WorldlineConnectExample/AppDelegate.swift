//
//  AppDelegate.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)

        let shop = StartViewController()
        let nav = UINavigationController(rootViewController: shop)

        window?.rootViewController = nav
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()

        return true
    }
}