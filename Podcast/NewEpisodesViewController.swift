//
//  NewEpisodesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NewEpisodesViewController: ViewController {

    var tableView: UITableView!
    var notifications = [NotificationActivity]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationEpisodeTableViewCell.self, forCellReuseIdentifier: NotificationEpisodeTableViewCell.identifier)
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
