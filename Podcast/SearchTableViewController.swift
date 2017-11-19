//
//  SearchTableViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 3/3/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//
import UIKit
import SnapKit
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

protocol SearchTableViewControllerDelegate: class {
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int)
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController)
    func searchTableViewControllerPresentSearchITunes(controller: SearchTableViewController)
}

class SearchTableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewCellDelegate, SearchITunesHeaderDelegate {
    
    var searchType: SearchType = .episodes
    let cellIdentifiersClasses: [SearchType: (String, AnyClass)] =
        [.episodes: ("EpisodeCell", SearchEpisodeTableViewCell.self),
         .series: ("SeriesCell", SearchSeriesTableViewCell.self),
         .people: ("PeopleCell", SearchPeopleTableViewCell.self)]
    
    let cellHeights: [SearchType: CGFloat] =
        [.episodes: 84,
         .series: 95,
         .people: 76]
    let searchITunesHeaderHeight: CGFloat = 79.5
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: []]
    
    var searchITunesHeaderView: SearchITunesHeaderView?
    var cellDelegate: SearchTableViewControllerDelegate?
    var tableView: EmptyStateTableView = EmptyStateTableView(frame: .zero, type: .search) //no delegate because no action button
    var continueInfiniteScroll: Bool = true
    var currentlyPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView = EmptyStateTableView(frame: .zero, type: .search)
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        tableView.loadingAnimation.center.y -= TabbedPageViewController.tabBarY
        tableView.delegate = self
        tableView.dataSource = self
        tableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        tableView.loadingAnimation.stopAnimating()
        tableView.addInfiniteScroll { tableView in
            self.fetchData(completion: nil)
        }
        
        //tells the infinite scroll when to stop
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }

        // Preload more data before reaching the bottom of scroll view.
        tableView.infiniteScrollTriggerOffset = 0.25 * view.frame.height

        view.addSubview(tableView)
        
        mainScrollView = tableView
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupSearchITunesHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = currentlyPlayingIndexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchEpisodeTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = nil
    }
    
    func setupSearchITunesHeader() {
        if searchType == .series && tableView.tableHeaderView == nil {
            searchITunesHeaderView = SearchITunesHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: searchITunesHeaderHeight))
            searchITunesHeaderView?.delegate = self
            tableView.tableHeaderView = searchITunesHeaderView
            
            searchITunesHeaderView?.snp.makeConstraints { make in
                make.width.top.centerX.equalToSuperview()
                make.height.equalTo(searchITunesHeaderHeight).priority(999)
            }
        }
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
    
    class func buildListOfAllSearchTableViewControllerTypes(order: [SearchType]) -> [SearchTableViewController] {
        let viewControllers = order.map { type -> SearchTableViewController in
            let searchTableViewControllerEpisodes = SearchTableViewController()
            searchTableViewControllerEpisodes.searchType = type
            return searchTableViewControllerEpisodes
        }
        return viewControllers
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
    
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let indexPath = tableView.indexPath(for:cell), let user = searchResults[.people]?[indexPath.row] as? User else { return }
        user.followChange(completion: cell.setFollowButtonState)
    }
    
    // MARK: SearchITunesHeaderViewDelegate
    func searchITunesHeaderDidPressSearchITunes(searchITunesHeader: SearchITunesHeaderView) {
        cellDelegate?.searchTableViewControllerPresentSearchITunes(controller: self)
    }
    
    func searchITunesHeaderDidPressDismiss(searchITunesHeader: SearchITunesHeaderView) {
        tableView.tableHeaderView = nil
    }
}
