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
    case all
    
    func toString() -> String {
        switch self {
        case .episodes:
            return "Episodes"
        case .series:
            return "Series"
        case .people:
            return "People"
        case .all:
            return "All"
        }
    }
}

protocol SearchTableViewControllerDelegate {
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int)
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController)
}

class SearchTableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewDelegate {
    
    var searchType: SearchType = .episodes
    let cellIdentifiersClasses: [SearchType: (String, AnyClass)] =
        [.episodes: ("EpisodeCell", SearchEpisodeTableViewCell.self),
         .series: ("SeriesCell", SearchSeriesTableViewCell.self),
         .people: ("PeopleCell", SearchPeopleTableViewCell.self)]
    
    let cellHeights: [SearchType: CGFloat] =
        [.episodes: 84,
         .series: 95,
         .people: 76]
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: []]
    
    var cellDelegate: SearchTableViewControllerDelegate?
    var tableView: EmptyStateTableView = EmptyStateTableView(frame: .zero, type: .search) //no delegate because no action button
    
    var continueInfiniteScroll: Bool = true
    var currentlyPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView = EmptyStateTableView(frame: view.frame, type: .search)
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.loadingAnimation.center.y -= TabbedPageViewController.tabBarY
        tableView.stopLoadingAnimation()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self 
        tableView.infiniteScrollIndicatorView = createLoadingAnimationView()
        tableView.addInfiniteScroll { tableView in
            self.fetchData(completion: nil)
        }
        //tells the infinite scroll when to stop
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        view.addSubview(tableView)
        mainScrollView = tableView
        
        automaticallyAdjustsScrollViewInsets = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = currentlyPlayingIndexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchEpisodeTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTableViewInsetsForAccessoryView()
        return searchResults[searchType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[searchType] ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

        return [searchTableViewControllerEpisodes, searchTableViewControllerSeries, searchTableViewControllerPeople]
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
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }
    
    func searchPeopleTableViewCell(cell: SearchPeopleTableViewCell, didSetFollowButton toNewValue: Bool) {
        guard let indexPath = tableView.indexPath(for:cell), let user = searchResults[.people]?[indexPath.row] as? User else { return }
        user.isFollowing = !user.isFollowing
        if user.isFollowing {
            let createFollowEndpointRequest = FollowUserEndpointRequest(userID: user.id)
            createFollowEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                user.isFollowing = true
                cell.setFollowButtonState(isFollowing: true)
            }
            createFollowEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                user.isFollowing = false
                cell.setFollowButtonState(isFollowing: false)
            }
            System.endpointRequestQueue.addOperation(createFollowEndpointRequest)
        } else {
            let deleteFollowEndpointRequest = UnfollowUserEndpointRequest(userID: user.id)
            deleteFollowEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                user.isFollowing = false
                cell.setFollowButtonState(isFollowing: false)
            }
            deleteFollowEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                user.isFollowing = true
                cell.setFollowButtonState(isFollowing: true)
            }
            System.endpointRequestQueue.addOperation(deleteFollowEndpointRequest)
        }
    }
}
