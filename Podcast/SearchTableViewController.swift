//
//  SearchTableViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 3/3/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum SearchType {
    case episodes
    case series
    case people
    case tags
}

class SearchTableViewController: UITableViewController {
    
    var searchType: SearchType!
    let cellIdentifiersClasses: [SearchType: (String, AnyClass)] =
        [.episodes: ("EpisodeCell", SearchEpisodeTableViewCell.self),
         .series: ("SeriesCell", SearchSeriesTableViewCell.self),
         .people: ("PeopleCell", SearchPeopleTableViewCell.self),
         .tags: ("TagCell", SearchTagTableViewCell.self)]
    let cellHeights: [SearchType: CGFloat] =
        [.episodes: 84,
         .series: 95,
         .people: 76,
         .tags: 53]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[searchType] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (cellIdentifier, _) = cellIdentifiersClasses[searchType] else { return UITableViewCell() }
        switch searchType! {
        case .episodes:
            let episode = Episode(id: 0, title: "185: Orland & Portlando (feat. Matt Spiel)", dateCreated: Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImage: #imageLiteral(resourceName: "filler_image"), largeArtworkImage: #imageLiteral(resourceName: "filler_image"), mp3URL: "")
            episode.seriesTitle = "Design Details"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchEpisodeTableViewCell else { return UITableViewCell() }
            cell.configure(for: episode)
            return cell
        case .series:
            let series = Series()
            series.smallArtworkImage = #imageLiteral(resourceName: "sample_series_artwork")
            series.title = "Design Details"
            series.publisher = "Spec"
            series.numberOfSubscribers = 12034
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchSeriesTableViewCell else { return UITableViewCell() }
            cell.configure(for: series)
            return cell
        case .people:
            let user = User()
            user.image = #imageLiteral(resourceName: "sample_profile_pic")
            user.name = "Sample User"
            user.username = "xXsampleuserXx"
            user.followersCount = 123
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else { return UITableViewCell() }
            cell.configure(for: user)
            return cell
        case .tags:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchTagTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "Swag"
            return cell
        }
    }
    
    class func buildListOfAllSearchTableViewControllerTypes() -> [UIViewController] {
        let searchTableViewControllerEpisodes = SearchTableViewController()
        searchTableViewControllerEpisodes.searchType = .episodes
        
        let searchTableViewControllerSeries = SearchTableViewController()
        searchTableViewControllerSeries.searchType = .series
        
        let searchTableViewControllerPeople = SearchTableViewController()
        searchTableViewControllerPeople.searchType = .people
        
        let searchTableViewControllerTags = SearchTableViewController()
        searchTableViewControllerTags.searchType = .tags

        return [searchTableViewControllerEpisodes, searchTableViewControllerSeries, searchTableViewControllerPeople, searchTableViewControllerTags]
    }
}
