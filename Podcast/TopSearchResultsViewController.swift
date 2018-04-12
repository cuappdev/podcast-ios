//
//  TopSearchResultsViewController.swift
//  Podcast
//
//  Created by Jack Thompson on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class TopSearchResultsViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SearchHeaderDelegate, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewCellDelegate {
    
    var searchResultsTableView: EmptyStateTableView!
    var searchITunesHeaderView: SearchHeaderView?
    let searchITunesHeaderHeight: CGFloat = 79.5
    var searchType: SearchType = .series
    var searchText: String!
    var didDismissItunesHeaderForQuery: Bool = false
    var searchDelayTimer: Timer?
    var currentlyPlayingIndexPath: IndexPath?
    var hasLoaded: Bool = false
    
    var searchResults: [Any] = []
    var pageSize: Int = 20
    var continueInfiniteScroll: Bool = true
    
    init(type: SearchType, query: String, results: [Any]) {
        searchType = type
        searchText = query
        searchResults = results
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = searchType.toString()
        
        searchResultsTableView = EmptyStateTableView(frame: .zero, type: .search)
        searchResultsTableView.emptyStateView.backgroundColor = .paleGrey
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.stopLoadingAnimation()
        searchResultsTableView.register(searchType.cells, forCellReuseIdentifier: searchType.identifiers)
        searchResultsTableView.estimatedRowHeight = searchType.cellHeight
        
        view.addSubview(searchResultsTableView)
        
        searchITunesHeaderView = SearchHeaderView(frame: .zero, type: .itunes)
        searchITunesHeaderView?.delegate = self
        addSearchITunesHeader()
        
        searchResultsTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        searchResultsTableView.addInfiniteScroll { _ -> Void in
            self.fetchData(query: self.searchText)
        }
        
        searchResultsTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        
        searchResultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hasLoaded = true
        
    }
    
    func addSearchITunesHeader() {
        guard !didDismissItunesHeaderForQuery && searchType == .series else {
            searchResultsTableView.tableHeaderView = nil
            return
        }
        
        searchResultsTableView.tableHeaderView = searchITunesHeaderView
        
        
        searchITunesHeaderView?.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(searchITunesHeaderHeight).priority(999)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultsTableView.reloadData()
    }
    
    // MARK: - SearchItunesHeaderViewDelegate
    
    func searchHeaderDidPress(searchHeader: SearchHeaderView) {
        let searchItunesViewController = SearchITunesViewController(query: searchText)
        navigationController?.pushViewController(searchItunesViewController, animated: true)
    }
    
    func searchHeaderDidPressDismiss(searchHeader: SearchHeaderView) {
        searchResultsTableView.tableHeaderView = nil
        didDismissItunesHeaderForQuery = true
    }

    func refreshController() {
        searchResultsTableView.finishInfiniteScroll()
        searchResultsTableView.reloadData()
        updateTableViewInsetsForAccessoryView()
    }
    
    func didSelect(_ cell: UITableViewCell, object: Any) {
        if let series = object as? Series {
            didTapOnCell(for: series)
        } else if let episode = object as? Episode {
            didTapOnCell(for: episode)
        } else if let user = object as? User {
            didTapOnCell(for: user)
        }
    }
    
    private func didTapOnCell(for series: Series) {
        let seriesDetailViewController = SeriesDetailViewController(series: series)
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }
    
    private func didTapOnCell(for episode: Episode) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    private func didTapOnCell(for user: User) {
        let externalProfileViewController = UserDetailViewController(user: user)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }
    
    func didTapOnSearchITunes() {
        let searchITunesViewController = SearchITunesViewController(query: searchText)
        navigationController?.pushViewController(searchITunesViewController, animated: true)
    }
    
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let indexPath = searchResultsTableView.indexPath(for: cell), let user = self.searchResults[indexPath.row] as? User else { return }
        user.followChange(completion: cell.setFollowButtonState)
    }
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = searchResultsTableView.indexPath(for: cell), let series = self.searchResults[indexPath.row] as? Series else { return }
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }
    
    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let indexPath = searchResultsTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let episode = self.searchResults[indexPath.row] as? Episode else { return }
        appDelegate.showAndExpandPlayer()
        Player.sharedInstance.playEpisode(episode: episode)
        cell.setPlayButtonToState(isPlaying: true)
        
        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != indexPath, let currentlyPlayingCell = searchResultsTableView.cellForRow(at: playingIndexPath) as? SearchEpisodeTableViewCell, let playingEpisode = searchResults[playingIndexPath.row] as? Episode {
            currentlyPlayingCell.setPlayButtonToState(isPlaying: playingEpisode.isPlaying)
        }
        
        currentlyPlayingIndexPath = indexPath
        updateTableViewInsetsForAccessoryView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchType.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        didSelect(cell, object: searchResults[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = searchType.identifiers
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchPeopleTableViewCell, let user = searchResults[indexPath.row] as? User {
            cell.configure(for: user, index: indexPath.row)
            cell.delegate = self
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchSeriesTableViewCell, let series = searchResults[indexPath.row] as? Series {
            cell.configure(for: series, index: indexPath.row)
            cell.delegate = self
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchEpisodeTableViewCell, let episode = searchResults[indexPath.row] as? Episode {
            cell.configure(for: episode, index: indexPath.row)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func fetchData(query: String) {
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: searchType.endpointType)
        let request = searchType.endpointType.init(modelPath: searchType.path, query: query, offset: searchResults.count, max: pageSize)
        request.success = { endpoint in
            guard let results = endpoint.processedResponseValue as? [Any] else { return }
            if results.count < self.pageSize { self.continueInfiniteScroll = false }
            self.searchResults = self.searchResults + results
            self.refreshController()
        }
        request.failure = { _ in
            self.searchResultsTableView.finishInfiniteScroll()
        }
        System.endpointRequestQueue.addOperation(request)
    }

}
