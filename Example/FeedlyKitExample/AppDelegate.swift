//
//  AppDelegate.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 03/03/2016.
//  Copyright (c) 2016 Hiroki Kumamoto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window                      = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController  = UINavigationController(rootViewController:ViewController(nibName: nil, bundle: nil))
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

