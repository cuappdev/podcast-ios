//
//  AppDelegate.swift
//  Recast
//
//  Created by Drew Dunne on 9/12/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: DataController!
    static var appDelegate: AppDelegate!

    override init() {
        super.init()
        AppDelegate.appDelegate = self
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        
        dataController = DataController() {
            let homeViewController = HomeViewController(nibName: nil, bundle: nil)
            let navController = UINavigationController(rootViewController: homeViewController)

            navController.navigationBar.barTintColor = .black
            navController.navigationBar.tintColor = .white
            navController.navigationBar.isOpaque = true
            navController.navigationBar.isTranslucent = false

            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navController.navigationBar.titleTextAttributes = textAttributes
            navController.navigationBar.largeTitleTextAttributes = textAttributes
            

            self.window = UIWindow()
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()

        }

        // Fabric
        #if DEBUG
        print("[Running Recast in debug configuration]")
        #else
        print("[Running Recast in release configuration]")
        Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
