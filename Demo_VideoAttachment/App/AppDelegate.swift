//
//  AppDelegate.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/22/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.makeKeyAndVisible()
            window.backgroundColor = .white
            let homeVC = HomeViewController()
            let navigationVC = UINavigationController(rootViewController: homeVC)
            window.rootViewController = navigationVC
        }
        return true
    }
}
