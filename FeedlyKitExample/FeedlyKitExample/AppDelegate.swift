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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window                      = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController  = UINavigationController(rootViewController:ViewController(nibName: nil, bundle: nil))
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {}
    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

