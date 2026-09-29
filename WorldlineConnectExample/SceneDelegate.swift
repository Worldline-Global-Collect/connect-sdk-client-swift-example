//
//  SceneDelegate.swift
//  WorldlineConnectExample
// 
//  Created for Worldline Global Collect on 17/09/2026.
//  Copyright © 2026 Worldline Global Collect. All rights reserved.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)

        let shop = StartViewController()
        let nav = UINavigationController(rootViewController: shop)

        window?.rootViewController = nav
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}
