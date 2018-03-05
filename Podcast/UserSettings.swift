//
//  UserSettings.swift
//  Podcast
//
//  Created by Drew Dunne on 10/23/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import AcknowList

class UserSettings: NSObject {

    static let sharedSettings = UserSettings()
    
    private var saveCounter: Int!
    private let maxSave: Int = 5
    
    var pushNotifications: Bool!
    
    private var pages: Dictionary<String, SettingsPage>!
    
    private override init() {
        saveCounter = 0
        pages = [:]
        super.init()
        loadData()
    }
    
    private func loadData() {
        pushNotifications = UserDefaults.standard.bool(forKey: "push_notifications")
    }
    
    func writeToFile() {
        UserDefaults.standard.set(pushNotifications, forKey: "push_notifications")
    }
    
    func add(section: String, header: String = "", footer: String = "", items: [SettingsField] = []) {
        // TODO: easier way to add sections
    }
    
    func add(field: String, to section: String, on page: String = "main_page", type: SettingsFieldType, label: String, onSave: @escaping ((Any) -> Void) = {_ in }, onTap: @escaping (() -> Void) = {}, placeholder: String = "") {
        // TODO: easier way to add fields
    }
    
    func add(page: String, to parent: String = "main_page", section: String, label: String) {
        pages[page] = SettingsPage(id: page, parent: parent, title: label) // Adds page
        self.add(field: "\(parent)_to_\(page)", to: section, on: parent, type: .disclosure, label: label) // Adds connector field
    }
    
    static let changeUsernamePage: SettingsPageViewController = {
        let changeUsernameVC = SettingsPageViewController()
        let settings = [
            SettingsSection(id: "username_field_section", items: [
                SettingsField(id: "username_field", title: "New Username", saveFunction: { text in
                    guard let username = text as? String, let user = System.currentUser else { return }
                    // TODO: add error handling
                    user.changeUsername(username: username, success: {
                        let alert = UIAlertController(title: "Success", message: "Changed username to @\(username)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { _ in changeUsernameVC.navigationController?.popViewController(animated: true)}))
                        changeUsernameVC.present(alert, animated: true, completion: nil)}, failure: {
                        changeUsernameVC.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil)
                    })
                }, type: .textField("@username"))
            ])
        ]
        changeUsernameVC.sections = settings
        changeUsernameVC.showSave = true
        changeUsernameVC.title = "Change Username"
        changeUsernameVC.returnOnSave = false
        return changeUsernameVC
    }()
    
    static var mainSettingsPage: SettingsPageViewController {
        get {
            let settingsViewController = SettingsPageViewController()
            var profileSettings = SettingsSection(id: "profile_settings", items: [
                SettingsField(id: "username_disclosure", title: "Change Username", type: .disclosure, tapAction: {
                    settingsViewController.navigationController?.pushViewController(UserSettings.changeUsernamePage, animated: true)
                }),
                ])
            profileSettings.items.append(SettingsField(id: "find_friends", title: "Find your Facebook friends", type: .disclosure, tapAction: {
                settingsViewController.navigationController?.pushViewController(FacebookFriendsViewController(), animated: true)
            }))
            if let current = System.currentUser {
                if !current.isFacebookUser && current.isGoogleUser {
                    let failure = {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
                        tabBarController.programmaticallyPressTabBarButton(atIndex: System.profileTab)
                        tabBarController.currentlyPresentedViewController?.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil)
                    }
                    profileSettings.items.append(SettingsField(id: "merge_account", title: "Add your Facebook account", type: .disclosure, tapAction: {
                        Authentication.sharedInstance.signInWithFacebook(viewController: settingsViewController, success: {
                            Authentication.sharedInstance.mergeAccounts(signInTypeToMergeIn: .Facebook, success: { _,_,_ in
                                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
                                tabBarController.programmaticallyPressTabBarButton(atIndex: System.profileTab)
                            } , failure: failure)}, failure: failure)
                    }))
                } else if !current.isGoogleUser && current.isFacebookUser {
                    GIDSignIn.sharedInstance().uiDelegate = settingsViewController
                    profileSettings.items.append(SettingsField(id: "merge_account", title: "Add your Google account", type: .disclosure, tapAction: {
                        Authentication.sharedInstance.signInWithGoogle()
                    }))
                }
            }
            let aboutSettings = SettingsSection(id: "about_settings", items: [
                    SettingsField(id: "acknowledgements", title: "Acknowledgements", type: .disclosure, tapAction: {
                        settingsViewController.navigationController?.pushViewController(AcknowListViewController(), animated: true)
                    })
                ])
            let settings = [
                profileSettings,
                aboutSettings,
                SettingsSection(id: "logout", items: [
                    SettingsField(id: "logout", title: "Log out", type: .button(.red), tapAction: {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in appDelegate.logout() }))
                        settingsViewController.present(alert, animated: true, completion: nil)
                    })
                ])
            ]
            settingsViewController.showSave = false
            settingsViewController.sections = settings
            settingsViewController.title = "Settings"
            return settingsViewController
        }
    }
}

