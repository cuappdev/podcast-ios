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
        guard let user = System.currentUser else { return [] }
        return [
            SettingsSection(id: "username_field_section", items: [
                SettingsField(id: "username_field", title: "New Username", saveFunction: { text in
                    guard let username = text as? String else { return }
                    // TODO: add error handling
                    let presentAlert =  { self.present(UIAlertController.changeUsernameFailed(), animated: true, completion: nil) }
                    user.changeUsername(username: username, success: {
                        self.present(UIAlertController.success(viewController: self, message: "Changed username to @\(username)"), animated: true, completion: nil)}, failure: presentAlert)
                }, type: .textField("@\(user.username)"))
                ])
        ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayerSettingsViewController: SettingsPageViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        sections = setupSettings()
        showSave = true
        title = "Player Settings"
        returnOnSave = false
    }

    func setupSettings() -> [SettingsSection] {
        return [
            SettingsSection(id: "player_rate_section", items: [
                SettingsField(id: "player_rate", title: "Default Rate:", saveFunction: { rate in
                    guard let playerRate = rate as? PlayerRate else { return }
                    UserPreferences.saveDefaultPlayerRate(rate: playerRate)
                    self.present(UIAlertController.success(viewController: self, message: "Saved default player settings"), animated: true, completion: nil)
                }, type: .slider)
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
    
class MainSettingsPageViewController: SettingsPageViewController, SignInUIDelegate, GIDSignInUIDelegate {

    init() {
        super.init(nibName: nil, bundle: nil)
        showSave = false
        sections = setupSettings()
        title = "Settings"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Authentication.sharedInstance.setDelegate(self)
    }

    func setupSettings() -> [SettingsSection] {
        let playerSettings = SettingsSection(id: "player_settings", items: [
            SettingsField(id: "player_settings", title: "Player Settings", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(PlayerSettingsViewController(), animated: true)
            })
        ])

        var profileSettings = SettingsSection(id: "profile_settings", items: [
            SettingsField(id: "username_disclosure", title: "Change Username", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(ChangeUsernameSettingsPageViewController(), animated: true)
            })
        ])

        let legalSettings = SettingsSection(id: "legal_settings", items: [
            SettingsField(id: "acknowledgements", title: "Acknowledgements", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(AcknowListViewController(), animated: true)
            }),
            SettingsField(id: "privacypolicy", title: "Privacy Policy", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(PrivacyPolicyViewController(), animated: true)
            }),
            SettingsField(id: "about", title: "About Us", type: .disclosure, tapAction: {
                self.navigationController?.pushViewController(AboutRecastViewController(), animated: true)
            })
        ])

        if let current = System.currentUser {
            if !current.isFacebookUser && current.isGoogleUser { // merge in Facebook
                profileSettings.items.append(SettingsField(id: "merge_account", title: "Add your Facebook account", type: .disclosure, tapAction: {
                    Authentication.sharedInstance.signIn(with: .Facebook, viewController: self)
                }))

            } else if !current.isGoogleUser && current.isFacebookUser { // merge Google
                profileSettings.items.append(SettingsField(id: "merge_account", title: "Add your Google account", type: .disclosure, tapAction: {
                    Authentication.sharedInstance.signIn(with: .Google, viewController: self)
                }))
            }

            if current.isFacebookUser {
                profileSettings.items.append(SettingsField(id: "find_friends", title: "Find your Facebook friends", type: .disclosure, tapAction: {
                    self.navigationController?.pushViewController(FacebookFriendsViewController(), animated: true)
                }))
            }
        }
        
        return [
            playerSettings,
            profileSettings,
            legalSettings,
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

    func finishedAccountMerge(for type: SignInType, with success: Bool) {
        if success {
            self.present(UIAlertController.success(viewController: self, message: "Merged \(type) account"), animated: true, completion: nil)
        } else {
            self.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }

    func signedIn(for type: SignInType, withResult result: SignInResult) {
        switch result {
        case .success:
            Authentication.sharedInstance.mergeAccounts(signInTypeToMergeIn: type, success: { _ in
                self.finishedAccountMerge(for: type, with: true)}, failure: { self.finishedAccountMerge(for: type, with: false)})
        case .cancelled:
            // TODO: this is buggy for Google login
            // might be google bug https://github.com/googlesamples/google-services/issues/302
            break
        case .failure:
            self.finishedAccountMerge(for: type, with: false)
        }
    }
}

