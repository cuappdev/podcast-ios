//
//  PodcastDetailViewController.swift
//  Recast
//
//  Created by Mindy Lou on 10/2/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class PodcastDetailViewController: UIViewController {

    // MARK: Data Variables
    var tableView: UITableView!
    var partialPodcast: PartialPodcast!
    var episodes: [Episode] = []

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // We can change this later
        return formatter
    }

    // MARK: Constants
    let episodeCellReuseIdentifier = "episodeCellReuseIdentifier"

    // MARK: View Lifecycle
    init(partialPodcast: PartialPodcast) {
        self.partialPodcast = partialPodcast
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodeCellReuseIdentifier)
        view.addSubview(tableView)

        setUpConstraints()
        loadFullPodcast()
    }

    func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func loadFullPodcast() {
        Podcast.loadFull(from: partialPodcast, success: { podcast in
            self.episodes = podcast.items
            self.tableView.reloadData()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { error in
            print("Error loading full podcast: \(error.localizedDescription)")
        }
    }

}

// MARK: - Table View Data Source
extension PodcastDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCellReuseIdentifier, for: indexPath)
            // swiftlint:disable:next force_cast
            as! EpisodeTableViewCell
        let episode = episodes[indexPath.row]
        cell.episodeNameLabel.text = episode.title
        cell.dateTimeLabel.text = dateFormatter.string(from: episode.pubDate ?? Date())
        cell.episodeDescriptionView.text = episode.description
        return cell
    }
}

// MARK: - Table View Delegate
extension PodcastDetailViewController: UITableViewDelegate {

}

// MARK: - Episode Action Delegate
extension PodcastDetailViewController: EpisodeActionDelegate {
    func startDownload(for cell: EpisodeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let episode = episodes[indexPath.row]
        print("episode download url is \(String(describing: episode.enclosure))") // need to convert enclosure to url!
    }

    func cancelDownload(for cell: EpisodeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let episode = episodes[indexPath.row]
        print("episode download url is \(String(describing: episode.enclosure))") // need to convert enclosure to url!
    }

    func resumeDownload(for cell: EpisodeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let episode = episodes[indexPath.row]
        print("episode download url is \(String(describing: episode.enclosure))") // need to convert enclosure to url!
    }
}
