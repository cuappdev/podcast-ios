
import UIKit
import GoogleSignIn
import AVFoundation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!
    
    var googleLoginViewController: GoogleLoginViewController!
    var tabBarController: TabBarController!
    var discoverViewController: DiscoverViewController!
    var feedViewController: FeedViewController!
    var internalProfileViewController: InternalProfileViewController!
    var bookmarkViewController: BookmarkViewController!
    var feedViewControllerNavigationController: UINavigationController!
    var playerViewController: PlayerViewController!
    var searchViewController: SearchViewController!
    var discoverViewControllerNavigationController: UINavigationController!
    var internalProfileViewControllerNavigationController: UINavigationController!
    var bookmarkViewControllerNavigationController: UINavigationController!
    var searchViewControllerNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        googleLoginViewController = GoogleLoginViewController()
        discoverViewController = DiscoverViewController()
        feedViewController = FeedViewController()
        internalProfileViewController = InternalProfileViewController()
        bookmarkViewController = BookmarkViewController()
        playerViewController = PlayerViewController()
        searchViewController = SearchViewController()
        
        discoverViewControllerNavigationController = NavigationController(rootViewController: discoverViewController)
        feedViewControllerNavigationController = NavigationController(rootViewController: feedViewController)
        internalProfileViewControllerNavigationController = NavigationController(rootViewController: internalProfileViewController)
        bookmarkViewControllerNavigationController = NavigationController(rootViewController: bookmarkViewController)
        searchViewControllerNavigationController = NavigationController(rootViewController: searchViewController)
        
        internalProfileViewControllerNavigationController.setNavigationBarHidden(true, animated: true)
        
        // Tab bar controller
        tabBarController = TabBarController()
        tabBarController.transparentTabBarEnabled = true
        tabBarController.numberOfTabs = 5
        tabBarController.setUnselectedImage(image: UIImage(named: "home_unselected_icon")!, forTabAtIndex: 0)
        tabBarController.setUnselectedImage(image: UIImage(named: "magnifying_glass_unselected_icon")!, forTabAtIndex: 1)
        tabBarController.setUnselectedImage(image: UIImage(named: "magnifying_glass_unselected_icon")!, forTabAtIndex: 2)
        tabBarController.setUnselectedImage(image: UIImage(named: "bookmark_unselected_icon")!, forTabAtIndex: 3)
        tabBarController.setUnselectedImage(image: UIImage(named: "profile_unselected_icon")!, forTabAtIndex: 4)
        tabBarController.setSelectedImage(image: UIImage(named: "home_selected_icon")!, forTabAtIndex: 0)
        tabBarController.setSelectedImage(image: UIImage(named: "magnifying_glass_selected_icon")!, forTabAtIndex: 1)
        tabBarController.setSelectedImage(image: UIImage(named: "magnifying_glass_selected_icon")!, forTabAtIndex: 2)
        tabBarController.setSelectedImage(image: UIImage(named: "bookmark_selected_icon")!, forTabAtIndex: 3)
        tabBarController.setSelectedImage(image: UIImage(named: "profile_selected_icon")!, forTabAtIndex: 4)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.feedViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 0)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.searchViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 1)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.discoverViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 2)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.bookmarkViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 3)
        
        tabBarController.addBlockToExecuteOnTabBarButtonPress(block: {
            self.tabBarController.present(self.internalProfileViewControllerNavigationController, animated: false, completion: nil)
        }, forTabAtIndex: 4)
        
        let loginNavigationController = UINavigationController(rootViewController: googleLoginViewController)
        loginNavigationController.setNavigationBarHidden(true, animated: false)
        
        // AVAudioSession
        NotificationCenter.default.addObserver(self, selector: #selector(beginInterruption), name: .AVAudioSessionInterruption, object: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AudioSession active!")
        } catch {
            print("No AudioSession!! Don't know what do to here. ")
        }
        
        // Main window setup
        window = UIWindow()
        
        window?.rootViewController = loginNavigationController
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    @objc func beginInterruption() {
        Player.sharedInstance.pause()
        print("interrupted")
    }
    
    func collapsePlayer(animated: Bool) {
        tabBarController.accessoryViewController?.collapseAccessoryViewController(animated: animated)
        tabBarController.showTabBar(animated: animated)
    }
    
    func expandPlayer(animated: Bool) {
        tabBarController.accessoryViewController?.expandAccessoryViewController(animated: true)
        tabBarController.hideTabBar(animated: true)
    }
    
    func showPlayer(animated: Bool) {
        if tabBarController.accessoryViewController == playerViewController { return }
        tabBarController.addAccessoryViewController(accessoryViewController: playerViewController)
        collapsePlayer(animated: false)
    }
    
    func didFinishAuthenticatingUser() {
        window?.rootViewController = tabBarController
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains("googleusercontent.apps") && url.absoluteString.contains("oauth2callback") {
            return googleLoginViewController.handleSignIn(url: url, options: options)
        }
        
        return false
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UserSettings.sharedSettings.writeToFile()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserSettings.sharedSettings.writeToFile()
    }
}

