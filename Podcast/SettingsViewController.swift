//
//  SettingsViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 3/8/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

// Element to display title
enum SettingsElements: String {
    case ChangeUsername = "Change Username"
    case PushNotifications = "Push Notifications"
}

class SettingsViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    let sectionsAndItems: [[SettingsElements]] = [
        [SettingsElements.ChangeUsername],
        [SettingsElements.PushNotifications],
    ]
    let reusableCellID = "settingsCell"
    let sectionSpacing: CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Settings"
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        tableView.showsVerticalScrollIndicator = true
        tableView.allowsSelection = false
        tableView.backgroundColor = .paleGrey
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: reusableCellID)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        mainScrollView = tableView
        view.addSubview(tableView)
    }

    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsAndItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsAndItems[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellID, for: indexPath) as? SettingsTableViewCell ?? SettingsTableViewCell()
        let setting = sectionsAndItems[indexPath.section][indexPath.row]
        cell.setTitle(setting.rawValue)
        switch setting {
        case .ChangeUsername:
            cell.accessoryType = .disclosureIndicator
            break
        case .PushNotifications:
            cell.accessoryType = .none
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionSpacing
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let setting = sectionsAndItems[indexPath.section][indexPath.row]
        switch setting {
        case .ChangeUsername:
            return true
        case .PushNotifications:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = sectionsAndItems[indexPath.section][indexPath.row]
        switch setting {
        case .ChangeUsername:
            tableView.deselectRow(at: indexPath, animated: true)
            let usernameVC = LoginUsernameViewController()
            usernameVC.user = System.currentUser!
            navigationController?.pushViewController(usernameVC, animated: true)
            break
        case .PushNotifications:
            break
        }
    }

}
