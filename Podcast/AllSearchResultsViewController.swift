//
//  AllSearchResultsViewController.swift
//  Podcast
//
//  Created by Jack Thompson on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class AllSearchResultsViewController: ViewController, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, SearchHeaderDelegate, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewCellDelegate {
    
    
    var searchController: UISearchController!
    var searchResultsTableView: EmptyStateTableView!
    var searchITunesHeaderView: SearchHeaderView?
    let searchITunesHeaderHeight: CGFloat = 79.5
    var searchType: SearchType = .series
    var searchText: String = ""
    var didDismissItunesHeaderForQuery: Bool = false
    var searchDelayTimer: Timer?
    var currentlyPlayingIndexPath: IndexPath?
    var hasLoaded: Bool = false
    
    var searchResults: [Any] = []
    var pageSize: Int = 20
    var continueInfiniteScroll: Bool = true
    var completingNewSearch: Bool = false
    
    convenience init(type: SearchType, query: String){
        self.init()
        searchType = type
        searchText = query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = searchType.toString()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchResultsTableView = EmptyStateTableView(frame: .zero, type: .search)
        searchResultsTableView.emptyStateView.backgroundColor = .paleGrey
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.startLoadingAnimation()
        searchResultsTableView.register(searchType.cells, forCellReuseIdentifier: searchType.identifiers)
        
        view.addSubview(searchResultsTableView)
        
        searchResultsTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        searchResultsTableView.addInfiniteScroll { _ -> Void in
            self.fetchData(query: self.searchText)
        }
        
        searchResultsTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.isHidden = true
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchITunesHeaderView = SearchHeaderView(frame: .zero, type: .itunes)
        searchITunesHeaderView?.delegate = self
        addSearchITunesHeader()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultsTableView.reloadData()
        searchController?.searchBar.isHidden = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchResultsTableView.isHidden = false
        didDismissItunesHeaderForQuery = false
        addSearchITunesHeader()
        mainScrollView = searchResultsTableView
        searchResultsTableView.startLoadingAnimation()
        searchResultsTableView.loadingAnimation.bringSubview(toFront: searchResultsTableView)
        updateTableViewInsetsForAccessoryView()
        completingNewSearch = true

        searchResultsTableView.reloadData()
        
        // put a timer on searching so not overloading with requests
        if let timer = searchDelayTimer {
            timer.invalidate()
            searchDelayTimer = nil
        }
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(searchAfterDelay), userInfo: nil, repeats: false)
    }
    
    @objc func searchAfterDelay() {
        fetchData(query: searchText)
    }
    
    // MARK: - SearchItunesHeaderViewDelegate
    
    func searchHeaderDidPress(searchHeader: SearchHeaderView) {
        let searchItunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchItunesViewController, animated: true)
    }
    
    func searchHeaderDidPressDismiss(searchHeader: SearchHeaderView) {
        searchResultsTableView.tableHeaderView = nil
        didDismissItunesHeaderForQuery = true
    }
    
    //MARK: - Search Results Delegate
    
    func refreshController(searchType: SearchType) {
        searchResultsTableView.finishInfiniteScroll()
        searchResultsTableView.stopLoadingAnimation()
        searchResultsTableView.reloadData()
        updateTableViewInsetsForAccessoryView()
    }
    
    func didSelectCell(cell: UITableViewCell, object: Any) {
        if let series = object as? Series {
            didTapOnSeriesCell(series: series)
        } else if let episode = object as? Episode {
            didTapOnEpisodeCell(episode: episode)
        } else if let user = object as? User {
            didTapOnUserCell(user: user)
        }
    }
    
    private func didTapOnSeriesCell(series: Series) {
        let seriesDetailViewController = SeriesDetailViewController(series: series)
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }
    
    private func didTapOnEpisodeCell(episode: Episode) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    private func didTapOnUserCell(user: User) {
        let externalProfileViewController = UserDetailViewController(user: user)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }
    
    func didTapOnSearchITunes() {
        let searchITunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchITunesViewController, animated: true)
    }
    
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let user = data.searchResults[indexPath.row] as? User else { return }
        user.followChange(completion: cell.setFollowButtonState)
    }
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let series = data.searchResults[indexPath.row] as? Series else { return }
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }
    
    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let episode = data.searchResults[indexPath.row] as? Episode else { return }
        appDelegate.showAndExpandPlayer()
        Player.sharedInstance.playEpisode(episode: episode)
        cell.setPlayButtonToState(isPlaying: true)
        
        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != indexPath, let currentlyPlayingCell = searchResultsTableView.cellForRow(at: playingIndexPath) as? SearchEpisodeTableViewCell, let playingEpisode = data.searchResults[playingIndexPath.row] as? Episode {
            currentlyPlayingCell.setPlayButtonToState(isPlaying: playingEpisode.isPlaying)
        }
        
        currentlyPlayingIndexPath = indexPath
        updateTableViewInsetsForAccessoryView()
    }
    
    func didPressViewAllButton(type: SearchType) {
        //do nothing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchType.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        didSelectCell(cell: cell, object: searchResults[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = searchType.identifiers
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchPeopleTableViewCell, let user = searchResults[indexPath.row] as? User {
            cell.configure(for: user, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchSeriesTableViewCell, let series = searchResults[indexPath.row] as? Series {
            cell.configure(for: series, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchEpisodeTableViewCell, let episode = searchResults[indexPath.row] as? Episode {
            cell.configure(for: episode, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        }
        return UITableViewCell()
    }
    
    func fetchData(query: String) {
        if completingNewSearch { continueInfiniteScroll = true }
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: searchType.endpointType)
        let request = searchType.endpointType.init(modelPath: searchType.path, query: query, offset: completingNewSearch ? 0 : searchResults.count, max: pageSize)
        request.success = { endpoint in
            guard let results = endpoint.processedResponseValue as? [Any] else { return }
            if results.count < self.pageSize { self.continueInfiniteScroll = false }
            if self.completingNewSearch {
                self.searchResults = results
            } else {
                self.searchResults = self.searchResults + results
            }
            self.completingNewSearch = false
            self.refreshController(searchType: self.searchType)
        }
        request.failure = { _ in
            self.completingNewSearch = false
        }
        System.endpointRequestQueue.addOperation(request)
    }

}

class SearchDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewCellDelegate {

    var searchResults: [Any] = []
    var searchType: SearchType
    var pageSize: Int = 20
    var continueInfiniteScroll: Bool = true
    var completingNewSearch: Bool = false // two types of searching: inifinite scroll or new search query -> true if a new search query in progress

    weak var delegate: SearchTableViewDelegate?

    init(searchType: SearchType) {
        self.searchType = searchType
    }

    func fetchData(query: String) {
        if completingNewSearch { continueInfiniteScroll = true }
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: searchType.endpointType)
        let request = searchType.endpointType.init(modelPath: searchType.path, query: query, offset: completingNewSearch ? 0 : searchResults.count, max: pageSize)
        request.success = { endpoint in
            guard let results = endpoint.processedResponseValue as? [Any] else { return }
            if results.count < self.pageSize { self.continueInfiniteScroll = false }
            if self.completingNewSearch {
                self.searchResults = results
            } else {
                self.searchResults = self.searchResults + results
            }
            self.completingNewSearch = false
            self.delegate?.refreshController(searchType: self.searchType)
        }
        request.failure = { _ in
            self.completingNewSearch = false
        }
        System.endpointRequestQueue.addOperation(request)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = searchType.identifiers
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchPeopleTableViewCell, let user = searchResults[indexPath.row] as? User {
            cell.configure(for: user, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchSeriesTableViewCell, let series = searchResults[indexPath.row] as? Series {
            cell.configure(for: series, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchEpisodeTableViewCell, let episode = searchResults[indexPath.row] as? Episode {
            cell.configure(for: episode, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchType.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        delegate?.didSelectCell(cell: cell, object: searchResults[indexPath.row])
    }

    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell) {
        delegate?.didPressPlayButton(cell: cell)
    }

    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        delegate?.didPressSubscribeButton(cell: cell)
    }

    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        delegate?.didPressFollowButton(cell: cell)
    }

}

