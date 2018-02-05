//
//  SearchViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

enum SearchType {
    case episodes
    case series
    case people

    static let allValues: [SearchType] = [.series, .episodes, .people]

    func toString() -> String {
        switch self {
        case .episodes:
            return "Episodes"
        case .series:
            return "Series"
        case .people:
            return "People"
        }
    }

    var endpointType: SearchEndpointRequest.Type {
        switch self {
        case .series:
            return SearchSeriesEndpointRequest.self
        case .episodes:
            return SearchEpisodesEndpointRequest.self
        case .people:
            return SearchUsersEndpointRequest.self
        }
    }

    var identifiers: String {
        switch self {
        case .series:
            return "SearchSeries"
        case .episodes:
            return "SearchEpisode"
        case .people:
            return "SearchPeople"
        }
    }

    var cells: UITableViewCell.Type {
        switch self {
        case .series:
            return SearchSeriesTableViewCell.self
        case .episodes:
            return SearchEpisodeTableViewCell.self
        case .people:
            return SearchPeopleTableViewCell.self
        }
    }

    var cellHeight: CGFloat {
        switch self {
        case .series:
            return SearchSeriesTableViewCell.height
        case .episodes:
            return SearchEpisodeTableViewCell.height
        case .people:
            return SearchPeopleTableViewCell.cellHeight
        }
    }

    var path: String {
        switch self {
        case .series:
            return "series"
        case .episodes:
            return "episodes"
        case .people:
            return "users"
        }
    }
}


class SearchViewController: ViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, ClearSearchFooterViewDelegate, TabBarDelegate, SearchTableViewDelegate, SearchITunesHeaderDelegate {

    var previousSearches: [String] = []
    var searchController: UISearchController!
    var pastSearchesTableView: EmptyStateTableView!
    var tabUnderlineView: UnderlineTabBarView!
    var searchResultsTableView: EmptyStateTableView!
    var searchITunesHeaderView: SearchITunesHeaderView?
    let searchITunesHeaderHeight: CGFloat = 79.5
    var tableViewData: [SearchDataSourceDelegate]!
    var hasLoaded: Bool = false
    var searchResults: [Any] = []
    let tabBarUnderlineViewHeight: CGFloat = 44
    var didDismissItunesHeaderForQuery: Bool = false
    var lastSearchText: String = ""
    var searchDelayTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite


        tableViewData = [SearchDataSourceDelegate(searchType: .series), SearchDataSourceDelegate(searchType: .episodes), SearchDataSourceDelegate(searchType: .people)]
        for data in tableViewData {
            data.delegate = self
        }

        searchResultsTableView = EmptyStateTableView(frame: .zero, type: .search)
        searchResultsTableView.dataSource = tableViewData[0]
        searchResultsTableView.delegate = tableViewData[0]
        searchResultsTableView.startLoadingAnimation()
        SearchType.allValues.forEach { searchType in
            searchResultsTableView.register(searchType.cells, forCellReuseIdentifier: searchType.identifiers)
        }
        view.addSubview(searchResultsTableView)

        searchResultsTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        searchResultsTableView.addInfiniteScroll { _ -> Void in
            if let data = self.searchResultsTableView.dataSource as? SearchDataSourceDelegate {
                data.fetchData(query: self.searchController.searchBar.text ?? "", newSearch: false)
            }
        }

        searchResultsTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            if let data = self.searchResultsTableView.dataSource as? SearchDataSourceDelegate {
                return data.continueInfiniteScroll
            }
            return false
        }

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        let cancelButtonAttributes: [NSAttributedStringKey : Any] = [.foregroundColor: UIColor.sea]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search"
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.titleView = searchController?.searchBar
        
        //IMPORTANT: Does not implement EmptyStateTableViewDelegate because pastSearch does not have an action button
        pastSearchesTableView = EmptyStateTableView(frame: .zero, type: .pastSearch)
        pastSearchesTableView.register(PreviousSearchResultTableViewCell.self, forCellReuseIdentifier: "PastSearchCell")
        pastSearchesTableView.delegate = self
        pastSearchesTableView.dataSource = self
        pastSearchesTableView.stopLoadingAnimation()
        let clearSearchView = ClearSearchFooterView()
        clearSearchView.frame.size.height = PreviousSearchResultTableViewCell.height
        clearSearchView.delegate = self
        pastSearchesTableView.tableFooterView = clearSearchView
        view.addSubview(pastSearchesTableView)
        mainScrollView = pastSearchesTableView

        tabUnderlineView = UnderlineTabBarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tabBarUnderlineViewHeight))
        tabUnderlineView.setUp(sections: SearchType.allValues.map{ type in type.toString() })
        tabUnderlineView.delegate = self
        view.addSubview(tabUnderlineView)
        tabUnderlineView.isHidden = true

        searchITunesHeaderView = SearchITunesHeaderView(frame: .zero)
        searchITunesHeaderView?.delegate = self
        addSearchITunesHeader()

        pastSearchesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tabUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(tabBarUnderlineViewHeight)
        }

        searchResultsTableView.snp.makeConstraints { make in
            make.top.equalTo(tabUnderlineView.snp.bottom)
            make.leading.trailing.width.bottom.equalToSuperview()
        }

        hasLoaded = true
    }

    func addSearchITunesHeader() {
        guard !didDismissItunesHeaderForQuery && tabUnderlineView.selectedIndex == 0 else {
            searchResultsTableView.tableHeaderView = nil
            return
        }
        searchResultsTableView.tableHeaderView = searchITunesHeaderView

        searchITunesHeaderView?.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(searchITunesHeaderHeight).priority(999)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: allow for a user to delete these searches as well
        super.viewDidAppear(animated)
        pastSearchesTableViewReloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController?.searchBar.isHidden = false
    }
    
    func pastSearchesTableViewReloadData() {
        previousSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] ?? []
        pastSearchesTableView.tableFooterView?.isHidden = previousSearches.isEmpty
        pastSearchesTableView.reloadData()
    }

    // MARK: - Search Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText != "" else {
            // if empty search text show previous search tableview
            if hasLoaded {
                tabUnderlineView.isHidden = true
                searchResultsTableView.isHidden = true
                pastSearchesTableView.isHidden = false
                pastSearchesTableViewReloadData()
                mainScrollView = pastSearchesTableView
            }
            return
        }
        if self.lastSearchText == searchText && pastSearchesTableView.isHidden { return }
        self.lastSearchText = searchText
        self.tabUnderlineView.isHidden = false
        self.searchResultsTableView.isHidden = false
        self.pastSearchesTableView.isHidden = true
        self.didDismissItunesHeaderForQuery = false
        self.addSearchITunesHeader()
        self.mainScrollView = self.searchResultsTableView
        self.searchResultsTableView.startLoadingAnimation()
        for data in self.tableViewData {
            data.searchResults = []
        }

        // put a timer on searching so not overloading with requests
        if let timer = searchDelayTimer {
            timer.invalidate()
            searchDelayTimer = nil
        }
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(searchAfterDelay), userInfo: nil, repeats: false)

        self.searchResultsTableView.reloadData()
        self.searchResultsTableView.loadingAnimation.bringSubview(toFront: self.searchResultsTableView)
        self.updateTableViewInsetsForAccessoryView()

    }

    @objc func searchAfterDelay() {
        for data in self.tableViewData {
            data.fetchData(query: lastSearchText, newSearch: true)
        }
    }

    // MARK: - Tab Bar Delegate

    func selectedTabDidChange(toNewIndex newIndex: Int) {
        addSearchITunesHeader()
        searchResultsTableView.dataSource = tableViewData[newIndex]
        searchResultsTableView.delegate = tableViewData[newIndex]
        if let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, data.completingNewSearch {
            searchResultsTableView.startLoadingAnimation()
        } else {
            searchResultsTableView.stopLoadingAnimation()
        }
        searchResultsTableView.reloadData()
    }

    // MARK: - SearchItunesHeaderViewDelegate

    func searchITunesHeaderDidPressSearchITunes(searchITunesHeader: SearchITunesHeaderView) {
        let searchItunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchItunesViewController, animated: true)
    }

    func searchITunesHeaderDidPressDismiss(searchITunesHeader: SearchITunesHeaderView) {
        searchResultsTableView.tableHeaderView = nil
        didDismissItunesHeaderForQuery = true
    }

    //MARK: - Tabbed Search Results Delegate

    func refreshController() {
        searchResultsTableView.finishInfiniteScroll()
        searchResultsTableView.reloadData()
        searchResultsTableView.stopLoadingAnimation()
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
        addPastSearches()
        let seriesDetailViewController = SeriesDetailViewController(series: series)
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }

    private func didTapOnEpisodeCell(episode: Episode) {
        addPastSearches()
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    private func didTapOnUserCell(user: User) {
        addPastSearches()
        let externalProfileViewController = ExternalProfileViewController(user: user)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }
    
    func didTapOnSearchITunes() {
        let searchITunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchITunesViewController, animated: true)
    }

    func didPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let user = data.searchResults[indexPath.row] as? User else { return }
        user.followChange(completion: cell.setFollowButtonState)
    }

    func didPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let series = data.searchResults[indexPath.row] as? Series else { return }
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }

    func didPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? SearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let episode = data.searchResults[indexPath.row] as? Episode else { return }
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        cell.setPlayButtonToState(isPlaying: true)
        updateTableViewInsetsForAccessoryView()
    }
    
    //MARK: -
    //MARK: PastSearchTableViewDelegate & Data source
    //MARK: -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PastSearchCell") as? PreviousSearchResultTableViewCell else { return UITableViewCell() }
        cell.label.text = previousSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousSearches.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PreviousSearchResultTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let priorSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] else { return }
        searchController.isActive = true
        searchController.searchBar.text = priorSearches[indexPath.row]
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }


    func addPastSearches() {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText == "" { return }
        if var userDefaultSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] {
            if !userDefaultSearches.contains(searchText) {
                userDefaultSearches.insert(searchText, at: 0)
                UserDefaults.standard.set(userDefaultSearches, forKey: "PastSearches")
            }
        } else {
            UserDefaults.standard.set([searchText], forKey: "PastSearches")
        }
    }
    
    //MARK:
    //MARK: PreviousSearchResultTableViewCell Delegate
    //MARK
    func didPressClearSearchHistoryButton() {
        UserDefaults.standard.set([], forKey: "PastSearches")
        pastSearchesTableViewReloadData()
    }
}

protocol SearchTableViewDelegate: class {
    func didSelectCell(cell: UITableViewCell, object: Any)
    func didPressFollowButton(cell: SearchPeopleTableViewCell)
    func didPressSubscribeButton(cell: SearchSeriesTableViewCell)
    func didPressPlayButton(cell: SearchEpisodeTableViewCell)
    func refreshController()
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

    func fetchData(query: String, newSearch: Bool = false) {
        if newSearch { continueInfiniteScroll = true }
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: searchType.endpointType)
        let request = searchType.endpointType.init(modelPath: searchType.path, query: query, offset: newSearch ? 0 : searchResults.count, max: pageSize)
        completingNewSearch = newSearch
        request.success = { endpoint in
            guard let results = endpoint.processedResponseValue as? [Any] else { return }
            self.completingNewSearch = false
            if results.count < self.pageSize { self.continueInfiniteScroll = false }
            if newSearch {
                self.searchResults = results
            } else {
                self.searchResults = self.searchResults + results
            }
            self.delegate?.refreshController()
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
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchEpisodeTableViewCell, let episode = searchResults[indexPath.row] as? Episode{
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
