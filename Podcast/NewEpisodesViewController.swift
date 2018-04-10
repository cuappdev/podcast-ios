//
//  NewEpisodesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NewEpisodesViewController: ViewController {

    // Dummy data for testing
    let dummyPerson = User(id: "1234", firstName: "Someone", lastName: "You Know", username: "someone", imageURL: nil, numberOfFollowers: 0, numberOfFollowing: 1, isFollowing: false, isFacebookUser: false, isGoogleUser: true)
    let dummyEpisode = Episode(id: "1234", title: "Dummy Episode", dateCreated: Date(), descriptionText: "Here's an episode", smallArtworkImageURL: nil, seriesID: "1234", largeArtworkImageURL: nil, audioURL: nil, duration: "1", seriesTitle: "Dummy Series", topics: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false, currentProgress: 0.0, isDurationWritten: false)

    var tableView: UITableView!
    var notifications = [NotificationActivity]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        mainScrollView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationEpisodeTableViewCell.self, forCellReuseIdentifier: NotificationEpisodeTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: NotificationsViewController.tabBarViewHeight, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
        loadNotifications()
    }

    func loadNotifications() {
        let notificationActivity1 = NotificationActivity(type: .follow(System.currentUser!), time: Date(), hasBeenRead: false)
        let notificationActivity2 = NotificationActivity(type: .share(dummyPerson, dummyEpisode), time: Date(), hasBeenRead: true)
        notifications = [notificationActivity1, notificationActivity2]
        tableView.reloadData()
    }

}

extension NewEpisodesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationEpisodeTableViewCell.identifier, for: indexPath) as? NotificationEpisodeTableViewCell else { return NotificationEpisodeTableViewCell() }
        cell.configure(for: notifications[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
