//
//  NotificationsViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NotificationsViewController: ViewController {

    // Dummy data for testing
    let dummyPerson = User(id: "1234", firstName: "Someone", lastName: "Someone", username: "someone", imageURL: nil, numberOfFollowers: 0, numberOfFollowing: 1, isFollowing: false, isFacebookUser: false, isGoogleUser: true)
    let dummyEpisode = Episode(id: "1234", title: "Dummy Episode", dateCreated: Date(), descriptionText: "Here's an episode", smallArtworkImageURL: nil, seriesID: "1234", largeArtworkImageURL: nil, audioURL: URL(string: "http://google.com"), duration: "1", seriesTitle: "Dummy Series", topics: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false, currentProgress: 0.0, isDurationWritten: false)
    let dummySeries = Series(id: "1234", title: "Dummy Series", author: "Dummy Author", smallArtworkImageURL: nil, largeArtworkImageURL: nil, topics: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())

    var tableView: UITableView!
    var notifications = [NotificationActivity]()

    weak var delegate: NotificationsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        mainScrollView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationFollowTableViewCell.self, forCellReuseIdentifier: NotificationFollowTableViewCell.identifier)
        tableView.register(NotificationEpisodeTableViewCell.self, forCellReuseIdentifier: NotificationEpisodeTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: NotificationsPageViewController.tabBarViewHeight, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorInset = .zero
        tableView.layoutIfNeeded()
        loadNotifications()
    }

    func loadNotifications() {
        let notificationActivity1 = NotificationActivity(type: .follow(System.currentUser!), time: Date(), hasBeenRead: true)
        let notificationActivity2 = NotificationActivity(type: .share(dummyPerson, dummyEpisode), time: Date(), hasBeenRead: true)
        let notificationActivity3 = NotificationActivity(type: .follow(dummyPerson), time: Date(), hasBeenRead: true)
        let notificationActivity4 = NotificationActivity(type: .newlyReleasedEpisode(dummySeries, dummyEpisode), time: Date(), hasBeenRead: true)
        let notificationActivity5 = NotificationActivity(type: .follow(System.currentUser!), time: Date(), hasBeenRead: false)
        let notificationActivity6 = NotificationActivity(type: .share(dummyPerson, dummyEpisode), time: Date(), hasBeenRead: false)
        let notificationActivity7 = NotificationActivity(type: .follow(dummyPerson), time: Date(), hasBeenRead: false)
        let notificationActivity8 = NotificationActivity(type: .newlyReleasedEpisode(dummySeries, dummyEpisode), time: Date(), hasBeenRead: false)
        notifications = [notificationActivity1, notificationActivity2, notificationActivity3, notificationActivity4]
        tableView.reloadData()

        let numUnread = notifications.filter { !$0.hasBeenRead }.count
        delegate?.updateNotificationCount(to: numUnread, for: self)
    }

}

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

    }
}
