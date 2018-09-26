//
//  MainSearchDataSourceDelegate.swift
//  Recast
//
//  Created by Jack Thompson on 9/26/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class MainSearchDataSourceDelegate: NSObject {

    // MARK: - Variables
    weak var delegate: SearchTableViewDelegate?
    var searchResults: [PartialPodcast] = []

    func fetchData(query: String) {
        SearchEndpoint(parameters: ["term": query, "media": "podcast", "limit": -1]).run()
            .success { (response: SearchResults) in
                self.searchResults = response.results
                self.delegate?.refreshController()
            }
            .failure { (error: Error) in
                print(error)
        }
    }

    func resetResults() {
        searchResults = []
    }

}

extension MainSearchDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next line_length
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.cellReuseIdentifier, for: indexPath)
            as? PodcastTableViewCell ?? PodcastTableViewCell()

        cell.setUp(podcast: searchResults[indexPath.row])
        return cell
    }
}

extension MainSearchDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
