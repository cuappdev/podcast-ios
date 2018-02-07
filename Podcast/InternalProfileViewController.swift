//
//  InternalProfileViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import Crashlytics

class InternalProfileViewController: ViewController, UITableViewDelegate, UITableViewDataSource, InternalProfileHeaderViewDelegate {
    
    var tableView: UITableView!
    var internalProfileHeaderView: InternalProfileHeaderView!
    
    let sectionsAndItems = [
        ["Listen History", "Downloads", "Subscriptions"],
        ["Settings"]
    ]
    let reusableCellID = "profileLinkCell"
    let sectionSpacing: CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Your Stuff"
        
        internalProfileHeaderView = InternalProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: InternalProfileHeaderView.height))
        internalProfileHeaderView.delegate = self
        if let currentUser = System.currentUser {
            internalProfileHeaderView.setUser(currentUser)
        }

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        tableView.backgroundColor = .paleGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true // NEED THIS
        tableView.register(InternalProfileTableViewCell.self, forCellReuseIdentifier: reusableCellID)
        tableView.tableHeaderView = internalProfileHeaderView
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mainScrollView = tableView
        view.addSubview(tableView)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: InternalProfileHeaderViewDelegate
    
    func internalProfileHeaderViewDidPressViewProfile(internalProfileHeaderView: InternalProfileHeaderView) {
        guard let currentUser = System.currentUser else { return }
        let myProfileViewController = ExternalProfileViewController(user: currentUser)        
        navigationController?.pushViewController(myProfileViewController, animated: true)
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsAndItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsAndItems[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InternalProfileTableViewCell.height
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellID, for: indexPath) as? InternalProfileTableViewCell ?? InternalProfileTableViewCell()
        cell.setTitle(sectionsAndItems[indexPath.section][indexPath.row])
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionSpacing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Move to view here
        switch (indexPath.section,indexPath.row) {
        case (0,0): //listening history
            let listeningHistoryViewController = ListeningHistoryViewController()
            navigationController?.pushViewController(listeningHistoryViewController, animated: true)
        case (0,1):
            navigationController?.pushViewController(UnimplementedViewController(), animated: true) //TODO
        case (0,2): //subscriptions
            let subscriptionsViewController = SubscriptionsViewController()
            navigationController?.pushViewController(subscriptionsViewController, animated: true)
        case (1,0): //settings
            navigationController?.pushViewController(UserSettings.mainSettingsPage, animated: true)
        default:
            break
        }
    }

}
