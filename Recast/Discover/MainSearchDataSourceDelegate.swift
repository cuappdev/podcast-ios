//
//  MainSearchDataSourceDelegate.swift
//  Recast
//
//  Created by Jack Thompson on 9/26/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import Kingfisher

class MainSearchDataSourceDelegate: NSObject {

    // MARK: - Variables
    weak var delegate: SearchTableViewDelegate?
    var searchResults: [PartialPodcast] = []

    // MARK: - Constants
    let cellReuseId = PodcastTableViewCell.cellReuseId

    func fetchData(query: String) {
        SearchEndpoint(parameters: ["term": query, "media": "podcast", "limit": -1]).run()
            .success { response in
                self.searchResults = response.results
                self.delegate?.refreshController()
            }
            .failure { error in
                print(error)
        }
    }

    func resetResults() {
        searchResults = []
    }
}

// MARK: - UITableViewDataSource
extension MainSearchDataSourceDelegate: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! PodcastTableViewCell
        let podcast = searchResults[indexPath.row]

        // Set up cell
        let artworkURL = podcast.artworkUrl600 ?? podcast.artworkUrl100 ?? podcast.artworkUrl60 ?? podcast.artworkUrl30
        cell.podcastImageView.kf.setImage(with: artworkURL)

        cell.podcastNameLabel.text = podcast.collectionName
        cell.podcastPublisherLabel.text = podcast.artistName

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainSearchDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let podcast = searchResults[indexPath.row]
        delegate?.didSelect(podcast)
    }
}
