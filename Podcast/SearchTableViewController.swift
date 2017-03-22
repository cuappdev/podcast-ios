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
    
    var string: String {
        switch self {
        case .episodes:
            return "Episodes"
        case .series:
            return "Series"
        case .people:
            return "People"
        case .tags:
            return "Tags"
        }
    }
}

protocol SearchTableViewControllerDelegate {
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int)
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController)
}

class SearchTableViewController: UITableViewController {
    
    var searchType: SearchType = .episodes
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
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: [],
        .tags: []]
    
    var cellDelegate: SearchTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.addInfiniteScroll { tableView in
            self.fetchData(nil)
        }        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults[searchType]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[searchType] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (cellIdentifier, _) = cellIdentifiersClasses[searchType], let results = searchResults[searchType] else { return UITableViewCell() }
        
        switch searchType {
        case .episodes:
            guard let episodes = results as? [Episode], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchEpisodeTableViewCell else { return UITableViewCell() }
            cell.configure(for: episodes[indexPath.row], index: indexPath.row)
            return cell
        case .series:
            guard let series = results as? [Series], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchSeriesTableViewCell else { return UITableViewCell() }
            cell.configure(for: series[indexPath.row], index: indexPath.row)
            return cell
        case .people:
            guard let people = results as? [User], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else{ return UITableViewCell() }
            cell.configure(for: people[indexPath.row], index: indexPath.row)
            return cell
        case .tags:
            guard let tags = results as? [Tag], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchTagTableViewCell else { return UITableViewCell() }
            cell.configure(tagName: tags[indexPath.row].name, index: indexPath.row)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDelegate?.searchTableViewController(controller: self, didTapSearchResultOfType: searchType, index: indexPath.row)
    }
        
    func fetchData(_ completionHandler: ((Void) -> Void)?) {
        cellDelegate?.searchTableViewControllerNeedsFetch(controller: self)
        completionHandler?()
    }
    
    class func buildListOfAllSearchTableViewControllerTypes() -> [SearchTableViewController] {
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
