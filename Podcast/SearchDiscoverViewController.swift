//
//  SearchDiscoverViewController.swift
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
    
    var index: Int {
        switch self {
        case .series:
            return 0
        case .episodes:
            return 1
        case .people:
            return 2
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


class SearchDiscoverViewController: ViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, ClearSearchFooterViewDelegate, SearchTableViewDelegate, SearchHeaderDelegate {
    
    var previousSearches: [String] = []
    var searchController: UISearchController!
    var pastSearchesTableView: EmptyStateTableView!
    var searchResultsTableView: EmptyStateTableView!
    var searchITunesHeaderView: SearchHeaderView?
    let searchITunesHeaderHeight: CGFloat = 79.5
    var tableViewData: MainSearchDataSourceDelegate!
    var hasLoaded: Bool = false
    var didDismissItunesHeaderForQuery: Bool = false
    var lastSearchText: String = ""
    var searchDelayTimer: Timer?
    var currentlyPlayingIndexPath: IndexPath?
    
    var discoverVC: DiscoverViewController!
    var discoverContainerView: UIView!
    
    var sections = SearchType.allValues
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        tableViewData = MainSearchDataSourceDelegate()
        tableViewData.delegate = self

        searchResultsTableView = EmptyStateTableView(frame: .zero, type: .search, style: .grouped)
        
        searchResultsTableView.dataSource = tableViewData
        searchResultsTableView.delegate = tableViewData
        
        searchResultsTableView.startLoadingAnimation()
        SearchType.allValues.forEach { searchType in
            searchResultsTableView.register(searchType.cells, forCellReuseIdentifier: searchType.identifiers)
        }
        view.addSubview(searchResultsTableView)

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchResultsTableView.emptyStateView.backgroundColor = .paleGrey

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

        searchITunesHeaderView = SearchHeaderView(frame: .zero, type: .itunes)
        searchITunesHeaderView?.delegate = self
        addSearchITunesHeader()

        pastSearchesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchResultsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        discoverContainerView = UIView()
        view.addSubview(discoverContainerView)
        
        discoverVC = DiscoverViewController()
        addChildViewController(discoverVC)
        discoverContainerView.addSubview(discoverVC.view)
        
        discoverContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        discoverVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        hasLoaded = true
    }

    func addSearchITunesHeader() {
        guard !didDismissItunesHeaderForQuery else {
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
        super.viewDidAppear(animated)
        pastSearchesTableViewReloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        searchResultsTableView.reloadData()
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
                searchResultsTableView.isHidden = true
                pastSearchesTableView.isHidden = false
                pastSearchesTableViewReloadData()
                mainScrollView = pastSearchesTableView
            }
            return
        }
        if lastSearchText == searchText && pastSearchesTableView.isHidden { return }
        lastSearchText = searchText
        searchResultsTableView.isHidden = false
        pastSearchesTableView.isHidden = true
        didDismissItunesHeaderForQuery = false
        addSearchITunesHeader()
        mainScrollView = searchResultsTableView
        searchResultsTableView.startLoadingAnimation()
        searchResultsTableView.loadingAnimation.bringSubview(toFront: searchResultsTableView)
        updateTableViewInsetsForAccessoryView()
        tableViewData.completingNewSearch = true
        
        searchResultsTableView.reloadData()

        // put a timer on searching so not overloading with requests
        if let timer = searchDelayTimer {
            timer.invalidate()
            searchDelayTimer = nil
        }
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(searchAfterDelay), userInfo: nil, repeats: false)
    }

    @objc func searchAfterDelay() {
        tableViewData.fetchData(query: lastSearchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        discoverContainerView.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        discoverContainerView.isHidden = true
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

    //MARK: - SearchTableViewDelegate

    func refreshController() {
        searchResultsTableView.stopLoadingAnimation()
        searchResultsTableView.finishInfiniteScroll()
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
        let externalProfileViewController = UserDetailViewController(user: user)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }
    
    func didTapOnSearchITunes() {
        let searchITunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchITunesViewController, animated: true)
    }

    func didPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? MainSearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let user = data.searchResults[indexPath.section][indexPath.row] as? User else { return }
        user.followChange(completion: cell.setFollowButtonState)
    }

    func didPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? MainSearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let series = data.searchResults[indexPath.section][indexPath.row] as? Series else { return }
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }

    func didPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? MainSearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let episode = data.searchResults[indexPath.section][indexPath.row] as? Episode else { return }
        appDelegate.showAndExpandPlayer()
        Player.sharedInstance.playEpisode(episode: episode)
        cell.setPlayButtonToState(isPlaying: true)

        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != indexPath, let currentlyPlayingCell = searchResultsTableView.cellForRow(at: playingIndexPath) as? SearchEpisodeTableViewCell, let playingEpisode = data.searchResults[playingIndexPath.section][playingIndexPath.row] as? Episode {
            currentlyPlayingCell.setPlayButtonToState(isPlaying: playingEpisode.isPlaying)
        }

        currentlyPlayingIndexPath = indexPath
        updateTableViewInsetsForAccessoryView()
    }
    
    func didPressViewAllButton(type: SearchType) {
        addPastSearches()
        let fullResultsController = AllSearchResultsViewController(type: type, query: lastSearchText)
        self.navigationController?.pushViewController(fullResultsController, animated: true)
    }
    
    //MARK: -
    //MARK: PastSearchTableViewDelegate & Data source
    //MARK: -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PastSearchCell") as? PreviousSearchResultTableViewCell else { return UITableViewCell() }
        cell.label.text = previousSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.removePastSearch(index: indexPath.row)
            self.pastSearchesTableViewReloadData()
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
    
    func removePastSearch(index: Int) {
        if var userDefaultSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] {
            userDefaultSearches.remove(at: index)
            UserDefaults.standard.set(userDefaultSearches, forKey: "PastSearches")
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
    func didPressViewAllButton(type: SearchType)
    func refreshController()
}

class MainSearchDataSourceDelegate: NSObject, UITableViewDelegate, UITableViewDataSource, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewCellDelegate, SearchTableViewHeaderDelegate {
    
    var searchTypes = SearchType.allValues
    var searchResults: [[Any]] = [[],[],[]]
    var previewSize: Int = 3
    var pageSize: Int = 20
    var completingNewSearch: Bool = false
    
    var searchProgress = 0
    
    var sectionHeaderHeight: CGFloat = 45.5
    
    weak var delegate: SearchTableViewDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(searchResults[section].count, previewSize)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchTypes.count
    }
    
    func fetchData(query: String) {
        self.searchProgress = 0
        for type in searchTypes {
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: type.endpointType)
            let request = type.endpointType.init(modelPath: type.path, query: query, offset: 0, max: pageSize)
            request.success = { endpoint in
                guard let results = endpoint.processedResponseValue as? [Any] else { return }
                self.searchResults[type.index] = results
                self.searchProgress += 1
                self.completingNewSearch = false
                if self.searchProgress == 3 {
                    self.delegate?.refreshController()
                    self.searchProgress = 0
                }
            }
            request.failure = { _ in
                self.completingNewSearch = false
            }
            System.endpointRequestQueue.addOperation(request)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchType.people.identifiers) as? SearchPeopleTableViewCell, let user = searchResults[indexPath.section][indexPath.row] as? User {
            cell.configure(for: user, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: SearchType.series.identifiers) as? SearchSeriesTableViewCell, let series = searchResults[indexPath.section][indexPath.row] as? Series {
            cell.configure(for: series, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: SearchType.episodes.identifiers) as? SearchEpisodeTableViewCell, let episode = searchResults[indexPath.section][indexPath.row] as? Episode {
            cell.configure(for: episode, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        }
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchTypes[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchResults[section].count == 0 ? 0 : sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard searchResults[section].count > 0 && !completingNewSearch else {
            return nil
        }
        let headerView = SearchSectionHeaderView(frame: .zero, type: searchTypes[section])
        headerView.delegate = self
        headerView.configure(type: searchTypes[section])
        if searchResults[section].count <= 3 {
            headerView.hideViewAllButton()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        delegate?.didSelectCell(cell: cell, object: searchResults[indexPath.section][indexPath.row])
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
    
    func searchTableViewHeaderDidPressViewAllButton(view: SearchSectionHeaderView) {
        delegate?.didPressViewAllButton(type: view.type)
    }
    
    
}

