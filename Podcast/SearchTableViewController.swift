//
//  SearchTableViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 3/3/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum SearchType {
    case episodes
    case series
    case people
    case tags
    case all
    
    func toString() -> String {
        switch self {
        case .episodes:
            return "Episodes"
        case .series:
            return "Series"
        case .people:
            return "People"
        case .tags:
            return "Tags"
        case .all:
            return "All"
        }
    }
}

protocol SearchTableViewControllerDelegate {
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int)
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController)
}

class SearchTableViewController: UITableViewController, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate {
    
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
    
    var currentlyPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.infiniteScrollIndicatorView = createLoadingAnimationView()
        tableView.addInfiniteScroll { tableView in
            self.fetchData(completion: nil)
        }
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = currentlyPlayingIndexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchEpisodeTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = nil
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
            if indexPath == currentlyPlayingIndexPath {
                cell.setPlayButtonToState(isPlaying: true)
            } else {
                cell.setPlayButtonToState(isPlaying: false)
            }
            cell.delegate = self
            return cell
        case .series:
            guard let series = results as? [Series], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchSeriesTableViewCell else { return UITableViewCell() }
            cell.configure(for: series[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        case .people:
            guard let people = results as? [User], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else{ return UITableViewCell() }
            cell.configure(for: people[indexPath.row], index: indexPath.row)
            return cell
        case .tags:
            guard let tags = results as? [Tag], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchTagTableViewCell else { return UITableViewCell() }
            cell.configure(tagName: tags[indexPath.row].name, index: indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDelegate?.searchTableViewController(controller: self, didTapSearchResultOfType: searchType, index: indexPath.row)
    }
        
    func fetchData(completion: (() -> ())?)  {
        cellDelegate?.searchTableViewControllerNeedsFetch(controller: self)
        completion?()
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
    
    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), indexPath != currentlyPlayingIndexPath, let episode = searchResults[.episodes]?[indexPath.row] as? Episode, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if let previousIndexPath = currentlyPlayingIndexPath, let previousCell = tableView.cellForRow(at: previousIndexPath) as? SearchEpisodeTableViewCell {
            previousCell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = indexPath
        cell.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
    }
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = tableView.indexPath(for:cell), let series = searchResults[.series]?[indexPath.row] as? Series else { return }
        series.isSubscribed = !series.isSubscribed
        if series.isSubscribed { //subscribing to series
            let createSubscriptionEndpointRequest = CreateUserSubscriptionEndpointRequest(seriesID: String(series.id))
            createSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = true
                cell.setSubscribeButtonToState(state: series.isSubscribed)
            }
            createSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = false
                cell.setSubscribeButtonToState(state: series.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(createSubscriptionEndpointRequest)
        } else {
            let deleteSubscriptionEndpointRequest = DeleteUserSubscriptionEndpointRequest(seriesID: String(series.id))
            deleteSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = false
                cell.setSubscribeButtonToState(state: series.isSubscribed)
            }
            deleteSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = true
                cell.setSubscribeButtonToState(state: series.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(deleteSubscriptionEndpointRequest)
        }
    }
}
