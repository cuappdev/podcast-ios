//
//  SearchDiscoverViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

enum SearchType: Int {
    case episodes = 0
    case series = 1
    case people = 2

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

protocol SearchTableViewDelegate: class {
    func didSelectCell(cell: UITableViewCell, object: Any)
    func didPressFollowButton(cell: SearchPeopleTableViewCell)
    func didPressSubscribeButton(cell: SearchSeriesTableViewCell)
    func didPressPlayButton(cell: SearchEpisodeTableViewCell)
    func didPressViewAllButton(type: SearchType, results: [SearchType: [Any]])
    func refreshController()
    func hideSearchFooter()
    func showSearchFooter()
}

class SearchDiscoverViewController: ViewController {

    override var usesLargeTitles: Bool { get { return false } }
    
    var previousSearches: [String] = []
    var searchController: UISearchController!
    var pastSearchesTableView: EmptyStateTableView!
    var searchResultsTableView: EmptyStateTableView!
    var searchFooterView: SearchFooterView!
    
    let searchITunesHeaderHeight: CGFloat = 67.5
    var tableViewData: MainSearchDataSourceDelegate!
    var hasLoaded: Bool = false
    var lastSearchText: String = ""
    var searchDelayTimer: Timer?
    var currentlyPlayingIndexPath: IndexPath?
    var pastSearchKey = "PastSearches"
    
    var discoverVC: DiscoverViewController!
    var discoverContainerView: UIView!
    
    var sections = SearchType.allValues
    
    let topOffset:CGFloat = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        tableViewData = MainSearchDataSourceDelegate()
        tableViewData.delegate = self

        searchResultsTableView = EmptyStateTableView(frame: .zero, type: .search, style: .grouped)
        searchResultsTableView.emptyStateView.delegate = self
        
        searchResultsTableView.sectionFooterHeight = 0
        searchResultsTableView.dataSource = tableViewData
        searchResultsTableView.delegate = tableViewData
        
        searchResultsTableView.emptyStateView.backgroundColor = .paleGrey
        
        searchResultsTableView.startLoadingAnimation()
        SearchType.allValues.forEach { searchType in
            searchResultsTableView.register(searchType.cells, forCellReuseIdentifier: searchType.identifiers)
        }
        view.addSubview(searchResultsTableView)
        
        searchFooterView = SearchFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: SearchFooterView.height))
        searchFooterView.delegate = self
        searchFooterView.isHidden = true
        
        searchResultsTableView.tableFooterView = searchFooterView
        
        searchResultsTableView.layoutSubviews()
        
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

        pastSearchesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchResultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        pastSearchesTableViewReloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController?.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController?.searchBar.isHidden = false
    }
    
    func pastSearchesTableViewReloadData() {
        previousSearches = UserDefaults.standard.value(forKey: pastSearchKey) as? [String] ?? []
        pastSearchesTableView.tableFooterView?.isHidden = previousSearches.isEmpty
        pastSearchesTableView.reloadData()
    }

    func addPastSearches() {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty { return }
        if var userDefaultSearches = UserDefaults.standard.value(forKey: pastSearchKey) as? [String] {
            if !userDefaultSearches.contains(searchText) {
                userDefaultSearches.insert(searchText, at: 0)
                UserDefaults.standard.set(userDefaultSearches, forKey: pastSearchKey)
            }
        } else {
            UserDefaults.standard.set([searchText], forKey: pastSearchKey)
        }
    }
    
    func removePastSearch(index: Int) {
        if var userDefaultSearches = UserDefaults.standard.value(forKey: pastSearchKey) as? [String] {
            userDefaultSearches.remove(at: index)
            UserDefaults.standard.set(userDefaultSearches, forKey: pastSearchKey)
        }
    }

}

// MARK: TableView Data Source
extension SearchDiscoverViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PastSearchCell") as? PreviousSearchResultTableViewCell else { return UITableViewCell() }
        cell.label.text = previousSearches[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { _, _ in
            self.removePastSearch(index: indexPath.row)
            self.pastSearchesTableViewReloadData()
        }
        delete.backgroundColor = .sea

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

}

// MARK: TableView Delegate
extension SearchDiscoverViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let priorSearches = UserDefaults.standard.value(forKey: pastSearchKey) as? [String] else { return }
        searchController.isActive = true
        searchController.searchBar.text = priorSearches[indexPath.row]
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }

}

// MARK: UISearchController Delegate
extension SearchDiscoverViewController: UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, searchText != "" else {
            if hasLoaded {
                searchResultsTableView.isHidden = true
                pastSearchesTableView.isHidden = false
                pastSearchesTableViewReloadData()
                mainScrollView = pastSearchesTableView
            }
            return
        }
        
        if lastSearchText == searchText && pastSearchesTableView.isHidden {
            return
        }
        
        hideSearchFooter()
        tableViewData.resetResults()
        lastSearchText = searchText
        searchResultsTableView.isHidden = false
        pastSearchesTableView.isHidden = true
    
        mainScrollView = searchResultsTableView
        searchResultsTableView.startLoadingAnimation()
        searchResultsTableView.loadingAnimation.bringSubview(toFront: searchResultsTableView)
        updateTableViewInsetsForAccessoryView()
        tableViewData.completingNewSearch = true
        
        searchResultsTableView.reloadData()

        if let timer = searchDelayTimer {
            timer.invalidate()
            searchDelayTimer = nil
        }
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(searchAfterDelay), userInfo: nil, repeats: false)
    }

    @objc func searchAfterDelay() {
        tableViewData.fetchData(query: lastSearchText)
    }
    
}

// MARK: SearchBar Delegate
extension SearchDiscoverViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        discoverContainerView.isHidden = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        discoverContainerView.isHidden = true
    }

}

// MARK: SearchFooterView Delegate
extension SearchDiscoverViewController: SearchFooterDelegate {

    func searchFooterDidPress(searchFooter: SearchFooterView) {
        let searchItunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchItunesViewController, animated: true)
    }

}

// MARK: EmptyStateView Delegate
extension SearchDiscoverViewController: EmptyStateViewDelegate {

    func didPressActionItemButton() {
        let searchItunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchItunesViewController, animated: true)
    }
    
    func emptyStateTableViewHandleRefresh() {
        refreshController()
    }

}

// MARK: ClearSearchFooterView Delegate
extension SearchDiscoverViewController: ClearSearchFooterViewDelegate {

    func didPressClearSearchHistoryButton() {
        UserDefaults.standard.set([], forKey: pastSearchKey)
        pastSearchesTableViewReloadData()
    }

}

// MARK: SearchTableView Delegate
extension SearchDiscoverViewController: SearchTableViewDelegate {

    func refreshController() {
        searchResultsTableView.stopLoadingAnimation()
        searchResultsTableView.finishInfiniteScroll()
        searchResultsTableView.reloadData()
        searchResultsTableView.layoutIfNeeded()
        updateTableViewInsetsForAccessoryView()
    }
    
    func hideSearchFooter() {
        searchFooterView.isHidden = true
    }
    
    func showSearchFooter() {
        searchFooterView.isHidden = false
    }

    func didSelectCell(cell: UITableViewCell, object: Any) {
        if let series = object as? Series {
            didTapOnCell(for: series)
        } else if let episode = object as? Episode {
            didTapOnCell(for: episode)
        } else if let user = object as? User {
            didTapOnCell(for: user)
        }
    }

    private func didTapOnCell(for series: Series) {
        addPastSearches()
        let seriesDetailViewController = SeriesDetailViewController(series: series)
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }

    private func didTapOnCell(for episode: Episode) {
        addPastSearches()
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    private func didTapOnCell(for user: User) {
        addPastSearches()
        let externalProfileViewController = UserDetailViewController(user: user)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }

    func didPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? MainSearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let user = data.searchResults[.people]![indexPath.row] as? User else { return }
        user.followChange(completion: cell.setFollowButtonState)
    }

    func didPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? MainSearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let series = data.searchResults[.series]![indexPath.row] as? Series else { return }
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }

    func didPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let data = searchResultsTableView.dataSource as? MainSearchDataSourceDelegate, let indexPath = searchResultsTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let episode = data.searchResults[.episodes]![indexPath.row] as? Episode else { return }
        appDelegate.showAndExpandPlayer()
        Player.sharedInstance.playEpisode(episode: episode)
        cell.setPlayButtonToState(isPlaying: true)

        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != indexPath, let currentlyPlayingCell = searchResultsTableView.cellForRow(at: playingIndexPath) as? SearchEpisodeTableViewCell, let playingEpisode = data.searchResults[.episodes]![playingIndexPath.row] as? Episode {
            currentlyPlayingCell.setPlayButtonToState(isPlaying: playingEpisode.isPlaying)
        }
        refreshController()
        currentlyPlayingIndexPath = indexPath
        updateTableViewInsetsForAccessoryView()
    }
    
    func didPressViewAllButton(type: SearchType, results: [SearchType: [Any]]) {
        addPastSearches()
        let fullResultsController = TopSearchResultsViewController(type: type, query: lastSearchText, results: results[type]!)
        self.navigationController?.pushViewController(fullResultsController, animated: true)
    }

}

class MainSearchDataSourceDelegate: NSObject {

    var searchTypes = SearchType.allValues
    var searchResults: [SearchType: [Any]] = [.people:[], .episodes:[], .series:[]]
    var previewSize: Int = 4
    var pageSize: Int = 20
    var completingNewSearch: Bool = false
    
    var endpointType = SearchAllEndpointRequest.self
    var path = "all"
    
    var sectionHeaderHeight: CGFloat = 55
    let firstSectionHeaderPadding: CGFloat = 16
    
    var areResults = true
    
    weak var delegate: SearchTableViewDelegate?

    func fetchData(query: String) {
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: endpointType)
        let request = endpointType.init(modelPath: path, query: query, offset: 0, max: pageSize)
        request.success = { endpoint in
            guard let results = endpoint.processedResponseValue as? [SearchType: [Any]] else { return }
            self.searchResults = results
            self.completingNewSearch = false
            if (self.searchResults[.series]?.isEmpty)! && (self.searchResults[.episodes]?.isEmpty)! && (self.searchResults[.people]?.isEmpty)! {
                self.delegate?.hideSearchFooter()
            }
            else { self.delegate?.showSearchFooter() }
            
            self.delegate?.refreshController()
            
            
        }
        request.failure = { _ in
            self.completingNewSearch = false
        }
        System.endpointRequestQueue.addOperation(request)
    }
    
    func resetResults() {
        self.searchResults = [.people:[], .episodes:[], .series:[]]
    }

}

// MARK: SearchEpisodeTableViewCell Delegate
extension MainSearchDataSourceDelegate: SearchEpisodeTableViewCellDelegate {
    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell) {
        delegate?.didPressPlayButton(cell: cell)
    }
}

// MARK: SearchSeriesTableView Delegate
extension MainSearchDataSourceDelegate: SearchSeriesTableViewDelegate {
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        delegate?.didPressSubscribeButton(cell: cell)
    }
}

// MARK: SearchPeopleTableViewCell Delegate
extension MainSearchDataSourceDelegate: SearchPeopleTableViewCellDelegate {
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        delegate?.didPressFollowButton(cell: cell)
    }
}

// MARK: SearchTableViewHeader Delegate
extension MainSearchDataSourceDelegate: SearchTableViewHeaderDelegate {
    func searchTableViewHeaderDidPressViewAllButton(view: SearchSectionHeaderView) {
        delegate?.didPressViewAllButton(type: view.type, results: searchResults)
    }
}

// MARK: TableView Data Source
extension MainSearchDataSourceDelegate: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return min(searchResults[searchTypes[section]]!.count, previewSize)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return completingNewSearch ? 0 : searchTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = searchTypes[indexPath.section]
        
        if searchResults[cellType]!.isEmpty {
            let cell = NoResultsTableViewCell(style: .default, reuseIdentifier: "noresults", type: cellType)
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchType.people.identifiers) as? SearchPeopleTableViewCell, let user = searchResults[cellType]![indexPath.row] as? User {
            cell.configure(for: user, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: SearchType.series.identifiers) as? SearchSeriesTableViewCell, let series = searchResults[cellType]![indexPath.row] as? Series {
            cell.configure(for: series, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: SearchType.episodes.identifiers) as? SearchEpisodeTableViewCell, let episode = searchResults[cellType]![indexPath.row] as? Episode {
            cell.configure(for: episode, index: indexPath.row)
            cell.delegate = self
            cell.isHidden = completingNewSearch
            return cell
        }
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResults[searchTypes[indexPath.section]]!.isEmpty ? NoResultsTableViewCell.height : searchTypes[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !(searchResults[searchTypes[section]]?.isEmpty)! else {
            return 0
        }
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !completingNewSearch && !(searchResults[searchTypes[section]]?.isEmpty)! else {
            return nil
        }
        
        let headerView = SearchSectionHeaderView(frame: .zero, type: searchTypes[section])
        headerView.delegate = self
        headerView.configure(type: searchTypes[section])
        if searchResults[searchTypes[section]]!.count <= 3 {
            headerView.hideViewAllButton()
        }
        return headerView
    }

}

// MARK: TableView Delegate
extension MainSearchDataSourceDelegate: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        delegate?.didSelectCell(cell: cell, object: searchResults[SearchType.allValues[indexPath.section]]![indexPath.row])
    }

}
