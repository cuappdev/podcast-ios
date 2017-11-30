
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
    var loginNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        googleLoginViewController = GoogleLoginViewController()
        discoverViewController = DiscoverViewController()
        feedViewController = FeedViewController()
        internalProfileViewController = InternalProfileViewController()
        bookmarkViewController = BookmarkViewController()
        playerViewController = PlayerViewController()
        searchViewController = SearchViewController()
        
        //discoverViewControllerNavigationController = NavigationController(rootViewController: discoverViewController)
        discoverViewControllerNavigationController = NavigationController(rootViewController: UnimplementedViewController())
        feedViewControllerNavigationController = NavigationController(rootViewController: feedViewController)
        internalProfileViewControllerNavigationController = NavigationController(rootViewController: internalProfileViewController)
        bookmarkViewControllerNavigationController = NavigationController(rootViewController: bookmarkViewController)
        searchViewControllerNavigationController = NavigationController(rootViewController: searchViewController)
        
        internalProfileViewControllerNavigationController.setNavigationBarHidden(true, animated: true)
        
        // Tab bar controller
        tabBarController = TabBarController()
        tabBarController.transparentTabBarEnabled = true
        tabBarController.addTab(index: System.feedTab, rootViewController: feedViewControllerNavigationController, selectedImage: #imageLiteral(resourceName: "home_tab_bar_selected"), unselectedImage: #imageLiteral(resourceName: "home_tab_bar_unselected"))
        tabBarController.addTab(index: System.discoverTab, rootViewController: discoverViewControllerNavigationController, selectedImage: #imageLiteral(resourceName: "discover_tab_bar_selected"), unselectedImage: #imageLiteral(resourceName: "discover_tab_bar_unselected"))
        tabBarController.addTab(index: System.searchTab, rootViewController: searchViewControllerNavigationController, selectedImage: #imageLiteral(resourceName: "search_tab_bar_selected"), unselectedImage: #imageLiteral(resourceName: "search_tab_bar_unselected"))
        tabBarController.addTab(index: System.bookmarkTab, rootViewController: bookmarkViewControllerNavigationController, selectedImage: #imageLiteral(resourceName: "bookmarks_tab_bar_selected"), unselectedImage: #imageLiteral(resourceName: "bookmarks_tab_bar_unselected"))
        tabBarController.addTab(index: System.profileTab, rootViewController: internalProfileViewControllerNavigationController, selectedImage: #imageLiteral(resourceName: "profile_tab_bar_selected"), unselectedImage: #imageLiteral(resourceName: "profile_tab_bar_unselected"))
        
        loginNavigationController = UINavigationController(rootViewController: googleLoginViewController)
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
    
    func logout() {
        googleLoginViewController.logout()
        window?.rootViewController = loginNavigationController
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.feedTab)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UserSettings.sharedSettings.writeToFile()
        Player.sharedInstance.saveListeningDurations()
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
        Player.sharedInstance.saveListeningDurations()
    }
}

