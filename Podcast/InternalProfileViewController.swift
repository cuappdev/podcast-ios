//
//  InternalProfileViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum InternalProfileSetting {
    case listeningHistory
    case downloads
    case facebook
    case bookmark

    var title: String {
        switch self {
        case .listeningHistory:
            return "Listening History"
        case .downloads:
            return "Downloads"
        case .bookmark:
            return "Saved for Later"
        case .facebook:
            return "Find Facebook Friends"
        }
    }
}

class InternalProfileViewController: ViewController, UITableViewDelegate, UITableViewDataSource, InternalProfileHeaderViewDelegate, EmptyStateTableViewDelegate {
    
    var settingsTableView: UITableView!
    var subscriptionsTableView: EmptyStateTableView!
    var internalProfileHeaderView: InternalProfileHeaderView!
    var subscriptions: [Series]?
    var headerView: UIView!
    
    var settingItems: [InternalProfileSetting] =
                    [.listeningHistory, .facebook, .downloads, .bookmark]

    let reusableCellID = "profileLinkCell"
    let reusableSubscriptionCellID = "subscriptionCell"
    let sectionSpacing: CGFloat = 18
    let headerViewHeight: CGFloat = 59.5
    let headerLabelSpacing: CGFloat = 12.5
    let headerMarginLeft: CGFloat = 18
    let nullStatePadding: CGFloat = 30
    var subscriptionTableViewHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Your Stuff"
        view.backgroundColor = .paleGrey
        
        internalProfileHeaderView = InternalProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: InternalProfileHeaderView.height))
        internalProfileHeaderView.delegate = self
        if let currentUser = System.currentUser {
            internalProfileHeaderView.setUser(currentUser)
        }

        let scrollView = ScrollView(frame: view.frame)
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainScrollView = scrollView

        settingsTableView = UITableView(frame: .zero)
        settingsTableView.backgroundColor = .paleGrey
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.allowsSelection = true // NEED THIS
        settingsTableView.alwaysBounceVertical = false
        settingsTableView.register(InternalProfileTableViewCell.self, forCellReuseIdentifier: reusableCellID)
        settingsTableView.tableHeaderView = internalProfileHeaderView
        settingsTableView.separatorInset = .zero
        scrollView.add(tableView: settingsTableView)
        subscriptionsTableView = EmptyStateTableView(frame: .zero, type: .subscription, startEmptyStateY: headerViewHeight + nullStatePadding)
        subscriptionsTableView.backgroundColor = .offWhite
        subscriptionsTableView.delegate = self
        subscriptionsTableView.dataSource = self
        subscriptionsTableView.showsVerticalScrollIndicator = false
        subscriptionsTableView.separatorStyle = .none
        subscriptionsTableView.alwaysBounceVertical = false
        subscriptionsTableView.emptyStateTableViewDelegate = self
        subscriptionsTableView.register(SearchSeriesTableViewCell.self, forCellReuseIdentifier: reusableSubscriptionCellID)
        scrollView.add(tableView: subscriptionsTableView)

        settingsTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(InternalProfileTableViewCell.height * CGFloat(settingItems.count) + InternalProfileHeaderView.height + sectionSpacing)
        }

        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight))
        headerView.backgroundColor = .paleGrey
        let label = UILabel()
        label.text = "Subscriptions"
        label.sizeToFit()
        label.font = ._14SemiboldFont()
        label.textColor = .charcoalGrey
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(headerLabelSpacing)
            make.leading.equalToSuperview().inset(headerMarginLeft)
        }

        remakeSubscriptionTableViewContraints()
    }

    func remakeSubscriptionTableViewContraints() {
        if let subs = subscriptions {
            subscriptionTableViewHeight = SearchSeriesTableViewCell.height * CGFloat(subs.count) + headerView.frame.height
            if subs.count == 0 { // so we can see null state background view
                subscriptionTableViewHeight = view.frame.height - settingsTableView.frame.maxX - headerView.frame.height
            }
            subscriptionsTableView.snp.remakeConstraints { make in
                make.top.equalTo(settingsTableView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(subscriptionTableViewHeight)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSubscriptions()
    }
    
    // MARK: InternalProfileHeaderViewDelegate
    
    func internalProfileHeaderViewDidPressViewProfile(internalProfileHeaderView: InternalProfileHeaderView) {
        guard let currentUser = System.currentUser else { return }
        let myProfileViewController = ExternalProfileViewController(user: currentUser)        
        navigationController?.pushViewController(myProfileViewController, animated: true)
    }

    func internalProfileHeaderViewDidPressSettingsButton(internalProfileHeaderView: InternalProfileHeaderView) {
        navigationController?.pushViewController(UserSettings.mainSettingsPage, animated: true)
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(tableView) {
        case subscriptionsTableView:
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView) {
        case settingsTableView:
            return settingItems.count
        case subscriptionsTableView where subscriptions != nil:
            return subscriptions!.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(tableView) {
        case settingsTableView:
            return InternalProfileTableViewCell.height
        case subscriptionsTableView:
            return SearchSeriesTableViewCell.height
        default:
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(tableView) {
        case settingsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellID, for: indexPath) as? InternalProfileTableViewCell ?? InternalProfileTableViewCell()
            cell.setTitle(settingItems[indexPath.row].title)
            cell.selectionStyle = .gray
            return cell
        case subscriptionsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reusableSubscriptionCellID, for: indexPath) as? SearchSeriesTableViewCell ?? SearchSeriesTableViewCell()
            if let series = subscriptions?[indexPath.row] {
                cell.configure(for: series, index: indexPath.row, showLastUpdatedText: true)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(tableView) {
        case settingsTableView:
            return sectionSpacing
        case subscriptionsTableView:
            return headerViewHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(tableView) {
        case settingsTableView:
            tableView.deselectRow(at: indexPath, animated: true)
            let internalSetting = settingItems[indexPath.row]
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
            switch internalSetting {
            case .listeningHistory:
                navigationController?.pushViewController(ListeningHistoryViewController(), animated: true)
            case .downloads:
                tabBarController.programmaticallyPressTabBarButton(atIndex: System.bookmarkTab) // TODO: switch to download section
            case .facebook:
                navigationController?.pushViewController(FacebookFriendsViewController(), animated: true)
            case .bookmark:
                tabBarController.programmaticallyPressTabBarButton(atIndex: System.bookmarkTab) // TODO: switch to bookmark section
            }
        case subscriptionsTableView:
            if let series = subscriptions?[indexPath.row] {
                let seriesDetailViewController = SeriesDetailViewController(series: series)
                navigationController?.pushViewController(seriesDetailViewController, animated: true)
            }
        default: break
        }
    }

    /// Endpoint Requests - Subscriptions

    func fetchSubscriptions() {

        guard let userID = System.currentUser?.id else { return }

        let userSubscriptionEndpointRequest = FetchUserSubscriptionsEndpointRequest(userID: userID)

        userSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let subscriptions = endpointRequest.processedResponseValue as? [Series] else { return }
            self.subscriptions = subscriptions.sorted { $0.lastUpdated > $1.lastUpdated }
            self.subscriptionsTableView.stopLoadingAnimation()
            self.subscriptionsTableView.reloadData()
            self.remakeSubscriptionTableViewContraints()
        }

        userSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            self.subscriptionsTableView.stopLoadingAnimation()
        }

        System.endpointRequestQueue.addOperation(userSubscriptionEndpointRequest)
    }

    // EmptyStateTableViewDelegate

    func didPressEmptyStateViewActionItem() {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.searchTab)
    }

    func emptyStateTableViewHandleRefresh() {
        // not necessary for this tableview
    }
}
