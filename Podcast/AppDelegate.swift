
import UIKit
import GoogleSignIn
import AVFoundation
import AudioToolbox
import FacebookCore
import FBSDKCoreKit
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!
    
    var loginViewController: LoginViewController!
    var tabBarController: TabBarController!

    var feedViewController: FeedViewController!
    var internalProfileViewController: InternalProfileViewController!
    var bookmarkViewController: BookmarkViewController!
    var discoverViewController: DiscoverViewController!
    var feedViewControllerNavigationController: UINavigationController!
    var playerViewController: PlayerViewController!
    var searchViewController: SearchViewController!
    var discoverViewControllerNavigationController: UINavigationController!
    var internalProfileViewControllerNavigationController: UINavigationController!
    var bookmarkViewControllerNavigationController: UINavigationController!
    var searchViewControllerNavigationController: UINavigationController!
    var loginNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Load downloaded saveData
        _ = DownloadManager.shared.loadAllData()
        
        setupViewControllers()

        // AVAudioSession
        NotificationCenter.default.addObserver(self, selector: #selector(beginInterruption), name: .AVAudioSessionInterruption, object: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AudioSession active!")
        } catch {
            print("No AudioSession!! Don't know what do to here. ")
        }


        // for Facebook login
        FBSDKSettings.setAppID(Keys.facebookAppID.value)
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Main window setup
        window = UIWindow()
        window?.rootViewController = loginNavigationController
        window?.makeKeyAndVisible()

        // If launched from a notification
        if let _ = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            // switch to notifications tab here
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
    
    @objc func beginInterruption() {
        Player.sharedInstance.pause()
        print("interrupted")
    }
    
    func collapsePlayer(animated: Bool) {
        tabBarController.accessoryViewController?.collapseAccessoryViewController(animated: animated)
        tabBarController.showTabBar(animated: animated)
    }

    // upon episode play, show mini player and animate to player
    func showAndExpandPlayer() {
        showPlayer(animated: false)
        expandPlayer(animated: true)
    }
    
    func expandPlayer(animated: Bool) {
        tabBarController.accessoryViewController?.expandAccessoryViewController(animated: animated)
        tabBarController.hideTabBar(animated: animated)
    }
    
    func showPlayer(animated: Bool) {
        if tabBarController.accessoryViewController == playerViewController { return }
        tabBarController.addAccessoryViewController(accessoryViewController: playerViewController)
        collapsePlayer(animated: false)
    }

    // called only for new users (go through onboarding)
    func didFinishAuthenticatingUser() {
        window?.rootViewController = tabBarController
    }

    // handles headphone events
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        if let e = event, e.type == .remoteControl {
            switch(e.subtype) {
            case .remoteControlPlay:
                Player.sharedInstance.play()
                break
            case .remoteControlPause, .remoteControlStop:
                Player.sharedInstance.pause()
                break
            case .remoteControlTogglePlayPause:
                Player.sharedInstance.togglePlaying()
                break
            default:
                break
            }
        }
    }

    func startOnboarding() {
        window?.rootViewController = OnboardingViewController()
    }

    func finishedOnboarding() {
        window?.rootViewController = tabBarController
        tabBarController.selectedIndex = System.discoverTab
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("googleusercontent.apps") && url.absoluteString.contains("oauth2callback") {
            return Authentication.sharedInstance.handleSignIn(url: url, options: options)
        } else {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
    }
    
    func logout() {
        // uncomment if we want a recast dialog to show up every time someone logs out
        // System.currentUser?.hasRecasted = false
        Player.sharedInstance.resetUponLogout()
        Authentication.sharedInstance.logout()
        window?.rootViewController = loginNavigationController
        tabBarController.selectedIndex = System.feedTab
        Cache.sharedInstance.reset()
        UserDefaults.standard.set([], forKey: "PastSearches")
        setupViewControllers()
    }

    func setupViewControllers() {
        loginViewController = LoginViewController()
        playerViewController = PlayerViewController()

        tabBarController = TabBarController()

        loginNavigationController = UINavigationController(rootViewController: loginViewController)
        loginNavigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func enterOfflineMode() {
        let downloadsViewController = DownloadsViewController(isOffline: true)
        window?.rootViewController = UINavigationController(rootViewController: downloadsViewController)
    }
    
    @objc func exitOfflineMode() {
        window?.rootViewController = loginNavigationController
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UserSettings.sharedSettings.writeToFile()
        _ = DownloadManager.shared.saveAllData()
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

    // MARK: - Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%%02.2hhx", $0) }.joined()
        print("Device token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register notifications: [error] \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch application.applicationState {
        case .active:
            print("App is active!")
        case .background, .inactive:
            print("Background/inactive: need to press tab to Notifications tab")
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // get user notification settings here
            // because they might change
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
