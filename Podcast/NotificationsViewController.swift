//
//  NotificationsViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum NotificationsViewControllerType {
    case newEpisodes
    case activity
}

/// ViewController instance that displays a list of notifications received.
/// Can be used to display two types of notifications: new episodes, and activity (follows + shares).
class NotificationsViewController: ViewController {

    // MARK: - UI Elements

    var tableView: EmptyStateTableView!
    var notifications = [NotificationActivity]()
    var notificationsType: NotificationsViewControllerType

    // right now large titles w/page view controllers are buggy
    override var usesLargeTitles: Bool { get { return false }}

    // MARK: - Constants

    var offset = 0
    let pageSize = 20
    let emptyStateYOffset: CGFloat = 134.5

    weak var delegate: NotificationsViewControllerDelegate?

    init(for notificationsType: NotificationsViewControllerType) {
        self.notificationsType = notificationsType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        switch notificationsType {
        case .activity:
            tableView = EmptyStateTableView(frame: .zero, type: .activity, isRefreshable: true, startEmptyStateY: emptyStateYOffset, style: .plain)
        case .newEpisodes:
            tableView = EmptyStateTableView(frame: .zero, type: .newEpisodes, isRefreshable: true, startEmptyStateY: emptyStateYOffset, style: .plain)
        }

        tableView.backgroundColor = .offWhite
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyStateTableViewDelegate = self
        tableView.register(NotificationFollowTableViewCell.self, forCellReuseIdentifier: NotificationFollowTableViewCell.identifier)
        tableView.register(NotificationEpisodeTableViewCell.self, forCellReuseIdentifier: NotificationEpisodeTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: NotificationsPageViewController.tabBarViewHeight, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorInset = .zero
        tableView.separatorColor = .silver
        tableView.layoutIfNeeded()
        tableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        tableView.addInfiniteScroll { _ in
            self.loadNotifications()
        }
        tableView.tableFooterView = UIView() // no lines if empty
        mainScrollView = tableView

        // mark as "read" on tab bar after tapping once
        delegate?.updateNotificationTabBarImage(to: false)

    }

    /// Loads new notifications from backend.
    /// - parameter canPullToRefresh: Whether or not the method is called from a pull to refresh.
    func loadNotifications(canPullToRefresh: Bool = false) {
        switch self.notificationsType {
        case .newEpisodes:
            let getNewEpisodesEndpointRequest = GetNewEpisodeNotificationsEndpointRequest(offset: offset, max: pageSize)
            getNewEpisodesEndpointRequest.success = { response in
                if canPullToRefresh { self.notifications = [] }
                guard let episodes = response.processedResponseValue as? [Episode] else { return }
                self.notifications = self.notifications + episodes.map {
                    NotificationActivity(type: .newlyReleasedEpisode($0.seriesTitle, $0), time: $0.dateCreated, isUnread: $0.isUnread)
                }
                self.offset += self.pageSize
                self.tableView.reloadData()
                self.tableView.finishInfiniteScroll()
                self.tableView.stopLoadingAnimation()
                self.tableView.endRefreshing()
                self.updateNotificationCount()
            }
            getNewEpisodesEndpointRequest.failure = { _ in
                self.tableView.finishInfiniteScroll()
                self.tableView.stopLoadingAnimation()
                self.tableView.endRefreshing()
                self.updateNotificationCount()
            }
            System.endpointRequestQueue.addOperation(getNewEpisodesEndpointRequest)
        case .activity:
            // todo: add endpoint request for activity notifications
            tableView.finishInfiniteScroll()
            tableView.stopLoadingAnimation()
            tableView.endRefreshing()
            updateNotificationCount()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        delegate?.updateNotificationTabBarImage(to: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func updateNotificationCount() {
        let numUnread = notifications.filter { $0.isUnread }.count
        delegate?.updateNotificationCount(to: numUnread, for: self)
        delegate?.updateNotificationTabBarImage(to: numUnread > 0)
    }

}

// MARK: - TableView

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch notifications[indexPath.row].notificationType {
        case .follow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowTableViewCell.identifier, for: indexPath) as? NotificationFollowTableViewCell else { return UITableViewCell() }
            cell.configure(for: notifications[indexPath.row])
            return cell
        case .share, .newlyReleasedEpisode:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationEpisodeTableViewCell.identifier, for: indexPath) as? NotificationEpisodeTableViewCell else { return UITableViewCell() }
            cell.configure(for: notifications[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]

        if notification.isUnread {
            delegate?.didTapNotification(notificationRead: notification.notificationType)
        }
        
        notification.isUnread = false
        tableView.reloadRows(at: [indexPath], with: .automatic)
        switch notifications[indexPath.row].notificationType {
        case .follow(let user):
            let userDetailViewController = UserDetailViewController(user: user)
            navigationController?.pushViewController(userDetailViewController, animated: true)
        case .share(_, let episode), .newlyReleasedEpisode(_, let episode):
            let episodeDetailViewController = EpisodeDetailViewController()
            episodeDetailViewController.episode = episode
            navigationController?.pushViewController(episodeDetailViewController, animated: true)
        }

        // updated unread notification counts
        let numUnread = notifications.filter { $0.isUnread }.count
        delegate?.updateNotificationCount(to: numUnread, for: self)
    }
}

// MARK: - EmptyStateTableViewDelegate
extension NotificationsViewController: EmptyStateTableViewDelegate {
    func didPressEmptyStateViewActionItem() {
        navigationController?.pushViewController(FacebookFriendsViewController(), animated: true)
    }

    func emptyStateTableViewHandleRefresh() {
        NotificationsPageViewController.saveReadNotifications(success: {
            self.offset = 0
            self.loadNotifications(canPullToRefresh: true)
        }, failure: {
            self.tableView.endRefreshing()
        })
    }

}

// TODO here: add functionality for episode bar button to play episodes from each view controller
