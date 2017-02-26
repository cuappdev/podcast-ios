//
//  AppDelegate.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!
    
    var loginVC: LoginViewController!
    var tabBarController: TabBarController!
    var searchViewController: SearchViewController!
    var discoverViewController: DiscoverViewController!
    var profileViewController: ProfileViewController!
    var searchViewControllerNavigationController: UINavigationController!
    var discoverViewControllerNavigationController: UINavigationController!
    var profileViewControllerNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Login VC initialization 
        loginVC = LoginViewController()
        
        searchViewController = SearchViewController()
        discoverViewController = DiscoverViewController()
        profileViewController = ProfileViewController()

        searchViewControllerNavigationController = UINavigationController(rootViewController: searchViewController)
        discoverViewControllerNavigationController = UINavigationController(rootViewController: discoverViewController)
        profileViewControllerNavigationController = UINavigationController(rootViewController: profileViewController)
        
        searchViewControllerNavigationController.setNavigationBarHidden(true, animated: true)
        discoverViewControllerNavigationController.setNavigationBarHidden(false, animated: true)
        profileViewControllerNavigationController.setNavigationBarHidden(true, animated: true)
        
        // Facebook Login configuration
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Main NavigationController initialization
        var firstVC : UIViewController?
        
        // Set view / FB user possibly
        if let accessToken = AccessToken.current {
            firstVC = tabBarController
            LoginViewController.setFBUser(authToken: accessToken.authenticationToken)
        } else {
            firstVC = loginVC
        }
        
        // Test tab bar controller
        tabBarController = TabBarController()
        tabBarController.transparentTabBarEnabled = true
        tabBarController.numberOfTabs = 4
        tabBarController.setUnselectedImage(image: UIImage(named: "home_unselected_icon")!, forTabAtIndex: 0)
        tabBarController.setUnselectedImage(image: UIImage(named: "magnifying_glass_unselected_icon")!, forTabAtIndex: 1)
        tabBarController.setUnselectedImage(image: UIImage(named: "bookmark_unselected_icon")!, forTabAtIndex: 2)
        tabBarController.setUnselectedImage(image: UIImage(named: "profile_unselected_icon")!, forTabAtIndex: 3)
        tabBarController.setSelectedImage(image: UIImage(named: "home_selected_icon")!, forTabAtIndex: 0)
        tabBarController.setSelectedImage(image: UIImage(named: "magnifying_glass_selected_icon")!, forTabAtIndex: 1)
        tabBarController.setSelectedImage(image: UIImage(named: "bookmark_selected_icon")!, forTabAtIndex: 2)
        tabBarController.setSelectedImage(image: UIImage(named: "profile_selected_icon")!, forTabAtIndex: 3)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.discoverViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 0)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.searchViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 1)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(UIViewController(), animated: false, completion: nil)
        }, forTabAtIndex: 2)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.profileViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 3)
        
        // Main window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = firstVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // OAuth for Facebook
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = SDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        debugPrint("Facebook User Logged In")
        window?.rootViewController = tabBarController
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func backButtonPress() {
        navigationController.popViewController(animated: false)
    }

}

