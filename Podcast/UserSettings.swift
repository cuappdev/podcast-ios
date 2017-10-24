//
//  UserSettings.swift
//  Podcast
//
//  Created by Drew Dunne on 10/23/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class UserSettings: NSObject {
    
    static let changeUsernamePage: SettingsPageViewController = {
        let changeUsernameVC = SettingsPageViewController()
        let settings = [
            SettingsSection(items: [
                SettingsField(title: "Username", saveFunction: { text in
                    guard let username = text as? String else { return }
                    let changeUsernameEndpointRequest = ChangeUsernameEndpointRequest(username: username)
                    changeUsernameEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                        if let resp = endpointRequest.processedResponseValue as? Dictionary<String, Any> {
                            System.currentUser = resp["user"] as? User
                            System.currentSession = resp["session"] as? Session
                        }
                        changeUsernameVC.navigationController?.popViewController(animated: true)
                    }
                    changeUsernameEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                        guard let resp = endpointRequest.processedResponseValue as? Dictionary<String, Any>,
                            let errors = resp["errors"] as? [String] else {
                            return
                        }
                        changeUsernameVC.setError(atIndex: IndexPath(row: 0, section: 0), withMessage: errors[0])
                    }
                    System.endpointRequestQueue.addOperation(changeUsernameEndpointRequest)
                }, type: .textField, placeholder: "new username")
                ])
        ]
        changeUsernameVC.sections = settings
        changeUsernameVC.showSave = true
        changeUsernameVC.title = "Change Username"
        changeUsernameVC.returnOnSave = false
        return changeUsernameVC
    }()
    
    static let mainSettingsPage: SettingsPageViewController = {
        let settingsViewController = SettingsPageViewController()
        let settings = [
            SettingsSection(items: [
                SettingsField(title: "Change Username", type: .disclosure, tapAction: {
                    settingsViewController.navigationController?.pushViewController(UserSettings.changeUsernamePage, animated: true)
                })
                ])
        ]
        settingsViewController.showSave = false
        settingsViewController.sections = settings
        settingsViewController.title = "Settings"
        return settingsViewController
    }()
}
