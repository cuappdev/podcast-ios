//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecommendedSeriesTableViewCellDataSource, RecommendedSeriesTableViewCellDelegate, RecommendedTagsTableViewCellDataSource, RecommendedTagsTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate {
    
    var tableView: UITableView!
    
    var series: [Series] = []
    var tags: [String] = []
    var episodes: [Episode] = []
    
    let FooterHeight: CGFloat = 10
    let sectionNames = ["Tags", "Series", "Episodes"]
    let sectionHeaderHeights: [CGFloat] = [1, 32, 32]
    let sectionContentClasses: [AnyClass] = [RecommendedTagsTableViewCell.self, RecommendedSeriesTableViewCell.self, RecommendedEpisodesOuterTableViewCell.self]
    let sectionContentIndentifiers = ["TagsCell", "SeriesCell", "EpisodesCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        view.backgroundColor = .white
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.searchBarStyle = .minimal
        searchBar.searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar.searchBar
        searchBar.searchBar.sizeToFit()
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight), style: .grouped)
        for (contentClass, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            tableView.register(contentClass.self, forCellReuseIdentifier: identifier)
        }
        tableView.backgroundColor = .podcastGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        
        // Populate with dummy data
        let s = Series()
        s.title = "Design Details"
        s.numberOfSubscribers = 832567
        series = Array(repeating: s, count: 7)
        tags = ["Education", "Politics", "Doggos", "Social Justice", "Design Thinking", "Science", "Mystery"]
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.series = s
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.tags = [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")]
        episodes = Array(repeating: episode, count: 5)
    }
    
    //MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // don't know how to condense this using an array like the other functions
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) else { return UITableViewCell() }
        if let cell = cell as? RecommendedTagsTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        } else if let cell = cell as? RecommendedSeriesTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        } else if let cell = cell as? RecommendedEpisodesOuterTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return FooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeights[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard sectionHeaderHeights[section] != 1 else { return nil }
        let header = DiscoverTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeights[section]))
        header.configure(sectionName: sectionNames[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return 150
        case 2:
            return CGFloat(episodes.count) * EpisodeTableViewCell.height
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: - RecommendedSeriesTableViewCell DataSource & Delegate
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, dataForItemAt indexPath: IndexPath) -> Series {
        return series[indexPath.row]
    }
    
    func numberOfRecommendedSeries(forRecommendedSeriesTableViewCell cell: RecommendedSeriesTableViewCell) -> Int {
        return series.count
    }
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, didSelectItemAt indexPath: IndexPath) {
        
        let seriesDetailViewController = SeriesDetailViewController()
        seriesDetailViewController.series = series[indexPath.row]
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
        
    }
    
    //MARK: - RecommendedTagsTableViewCell DataSource & Delegate
    
    func recommendedTagsTableViewCell(cell: RecommendedTagsTableViewCell, dataForItemAt indexPath: IndexPath) -> String {
        return tags[indexPath.row]
    }
    
    func numberOfRecommendedTags(forRecommendedTagsTableViewCell cell: RecommendedTagsTableViewCell) -> Int {
        return tags.count
    }
    
    func recommendedTagsTableViewCell(cell: RecommendedTagsTableViewCell, didSelectItemAt indexPath: IndexPath) {
        print("Selected tag at \(indexPath.row)")
    }
    
    //MARK: - RecommendedEpisodesOuterTableViewCell DataSource & Delegate
    
    func recommendedEpisodesTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, dataForItemAt indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
    
    func numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell cell: RecommendedEpisodesOuterTableViewCell) -> Int {
        return episodes.count
    }
    
    func recommendedEpisodesOuterTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, didSelectItemAt indexPath: IndexPath) {
        print("Selected episode at \(indexPath.row)")
    }
}
