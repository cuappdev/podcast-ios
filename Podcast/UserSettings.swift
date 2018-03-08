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
}

// MARK
// MARK - Settings Classes
// MARK
class ChangeUsernameSettingsPageViewController: SettingsPageViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        sections = setupSettings()
        showSave = true
        title = "Change Username"
        returnOnSave = false
    }

    func setupSettings() -> [SettingsSection] {
        return
        [
            SettingsSection(id: "username_field_section", items: [
                SettingsField(id: "username_field", title: "New Username", saveFunction: { text in
                    guard let username = text as? String, let user = System.currentUser else { return }
                    // TODO: add error handling
                    let presentAlert =  { self.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil) }
                    user.changeUsername(username: username, success: {
                        let alert = UIAlertController(title: "Success", message: "Changed username to @\(username)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { _ in self.navigationController?.popViewController(animated: true)}))
                        self.present(alert, animated: true, completion: nil)}, failure: presentAlert)
                }, type: .textField("@username"))
                ])
        ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK
// MARK - Settings Classes
// MARK
    
class MainSettingsPageViewController: SettingsPageViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        showSave = false
        sections = setupSettings()
        title = "Settings"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSettings() -> [SettingsSection] {
        var profileSettings = SettingsSection(id: "profile_settings", items: [
            SettingsField(id: "username_disclosure", title: "Change Username", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(ChangeUsernameSettingsPageViewController(), animated: true)
            })
        ])

        let aboutSettings = SettingsSection(id: "about_settings", items: [
            SettingsField(id: "acknowledgements", title: "Acknowledgements", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(AcknowListViewController(), animated: true)
            }),
            SettingsField(id: "privacypolicy", title: "Privacy Policy", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(PrivacyPolicyViewController(), animated: true)
            })
        ])
//
//        profileSettings.items.append(SettingsField(id: "find_friends", title: "Find your Facebook friends", type: .disclosure, tapAction: {
//            settingsViewController.navigationController?.pushViewController(FacebookFriendsViewController(), animated: true)
//        }))
        if let current = System.currentUser {
            if !current.isFacebookUser && current.isGoogleUser { // merge in Facebook
                let failure = { self.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil) }
                profileSettings.items.append(SettingsField(id: "merge_account", title: "Add your Facebook account", type: .disclosure, tapAction: {
                    Authentication.sharedInstance.signInWithFacebook(viewController: self, success: {
                        Authentication.sharedInstance.mergeAccounts(signInTypeToMergeIn: .Facebook, success: { _,_,_ in
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
                            tabBarController.programmaticallyPressTabBarButton(atIndex: System.profileTab)
                        }, failure: failure)}, failure: failure)
                }))

            } else if !current.isGoogleUser && current.isFacebookUser { // merge Google
                GIDSignIn.sharedInstance().uiDelegate = self
                profileSettings.items.append(SettingsField(id: "merge_account", title: "Add your Google account", type: .disclosure, tapAction: {
                    Authentication.sharedInstance.signInWithGoogle()
                }))
            }

            if current.isFacebookUser {
                profileSettings.items.append(SettingsField(id: "find_friends", title: "Find your Facebook friends", type: .disclosure, tapAction: {
                    self.navigationController?.pushViewController(FacebookFriendsViewController(), animated: true)
                }))
            }
        }
        
        return [
            profileSettings,
            aboutSettings,
            SettingsSection(id: "logout", items: [
                SettingsField(id: "logout", title: "Log out", type: .button(.red), tapAction: {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in appDelegate.logout() }))
                    self.present(alert, animated: true, completion: nil)
                })
            ])
        ]
    }
}

