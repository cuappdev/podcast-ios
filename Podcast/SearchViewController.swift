//
//  SearchViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: ViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, TabbedViewControllerSearchResultsControllerDelegate, ClearSearchFooterViewDelegate {

    var previousSearches: [String] = []
    var searchController: UISearchController!
    var searchResultsController: TabbedPageViewController!
    var pastSearchesTableView: EmptyStateTableView!
    var tabUnderlineView: UnderlineTabBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        
        searchResultsController = TabbedPageViewController()
        view.addSubview(searchResultsController.view)
        
        searchResultsController.searchResultsDelegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController

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
        
        //IMPORTANT: Does not implement EmptyStateTableViewDelegate because pastSearch does not have an action button s
        pastSearchesTableView = EmptyStateTableView(frame: view.frame, type: .pastSearch)
        pastSearchesTableView.register(PreviousSearchResultTableViewCell.self, forCellReuseIdentifier: "PastSearchCell")
        pastSearchesTableView.delegate = self
        pastSearchesTableView.dataSource = self
        pastSearchesTableView.stopLoadingAnimation()
        let clearSearchView = ClearSearchFooterView()
        clearSearchView.frame.size.height = PreviousSearchResultTableViewCell.height
        clearSearchView.delegate = self
        pastSearchesTableView.tableFooterView = clearSearchView
        pastSearchesTableView.contentInset.bottom = pastSearchesTableView.contentInset.bottom + PreviousSearchResultTableViewCell.height
        view.addSubview(pastSearchesTableView)
        mainScrollView = pastSearchesTableView
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
        searchResultsController.subviewsWillAppear()
    }
    
    override func updateTableViewInsetsForAccessoryView() {
        super.updateTableViewInsetsForAccessoryView()
        searchResultsController.subviewsWillAppear()
    }
    
    func pastSearchesTableViewReloadData() {
        previousSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] ?? []
        pastSearchesTableView.tableFooterView?.isHidden = previousSearches.isEmpty
        pastSearchesTableView.reloadData()
    }
    
    //MARK: - Tabbed Search Results Delegate
    func didTapOnSeriesCell(series: Series) {
        addPastSearches()
        let seriesDetailViewController = SeriesDetailViewController(series: series)
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }

    func didTapOnEpisodeCell(episode: Episode) {
        addPastSearches()
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    func didTapOnUserCell(user: User) {
        addPastSearches()
        let externalProfileViewController = ExternalProfileViewController(user: user)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }
    
    func didTapOnSearchITunes() {
        let searchITunesViewController = SearchITunesViewController(query: searchController.searchBar.text ?? "")
        navigationController?.pushViewController(searchITunesViewController, animated: true)
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
    
    //MARK: -
    //MARK: UITableViewDelegate & Data source
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
    
    //MARK:
    //MARK: PreviousSearchResultTableViewCell Delegate
    //MARK
    func didPressClearSearchHistoryButton() {
        UserDefaults.standard.set([], forKey: "PastSearches")
        pastSearchesTableViewReloadData()
    }
    
}
