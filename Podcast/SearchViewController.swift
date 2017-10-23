//
//  SearchViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: ViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, TabbedViewControllerSearchResultsControllerDelegate {

    var pastSearches: Set<String>? //keep around a set so we don't have duplicates
    var searchController: UISearchController!
    var searchResultsController: TabbedPageViewController!
    var pastSearchesTableView: UITableView!
    var tabUnderlineView: UnderlineTabBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        view.backgroundColor = .offWhite
        
        searchResultsController = TabbedPageViewController()
        view.addSubview(searchResultsController.view)
        
        searchResultsController.searchResultsDelegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController

        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.sea]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey: Any], for: .normal)
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search"
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.titleView = searchController?.searchBar
        
        pastSearchesTableView = UITableView(frame: CGRect.zero)
        pastSearchesTableView.backgroundColor = .offWhite
        pastSearchesTableView.backgroundView = EmptyStateView(type: .pastSearch)
        pastSearchesTableView.backgroundView!.isHidden = true
        pastSearchesTableView.register(PastSearchTableViewCell.self, forCellReuseIdentifier: "PastSearchCell")
        pastSearchesTableView.delegate = self
        pastSearchesTableView.dataSource = self
        pastSearchesTableView.separatorStyle = .none
        view.addSubview(pastSearchesTableView)
        
        pastSearchesTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(appDelegate.tabBarController.tabBarHeight)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let priorSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] {
            pastSearches = Set(priorSearches)
        } else {
            pastSearches = nil 
        }
        reloadPastSearchTableViewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController?.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController?.searchBar.isHidden = false
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
        let externalProfileViewController = ExternalProfileViewController()
        externalProfileViewController.fetchUser(id: user.id)
        navigationController?.pushViewController(externalProfileViewController, animated: true)
    }
    
    func addPastSearches() {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText == "" { return }
        if var searches = pastSearches {
            if !(searches.contains(searchText)) {
                searches.insert(searchText)
                UserDefaults.standard.set(Array(searches), forKey: "PastSearches")
            }
        } else {
            UserDefaults.standard.set([searchText], forKey: "PastSearches")
        }
    }
    
    //MARK: -
    //MARK: UITableViewDelegate & Data source
    //MARK: -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PastSearchCell") as? PastSearchTableViewCell, let priorSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String]  else { return UITableViewCell() }
        cell.label.text = priorSearches[priorSearches.count - indexPath.row - 1] //searches are stored in reverse order due to nature of appending to array
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searches = pastSearches {
            return searches.count
        }
        return 0
    }
    
    func reloadPastSearchTableViewData() {
        if let _ = pastSearches {
            pastSearchesTableView.backgroundView?.isHidden = true
        } else {
            pastSearchesTableView.backgroundView?.isHidden = false
        }
        pastSearchesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PastSearchTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let priorSearches = UserDefaults.standard.value(forKey: "PastSearches") as? [String] else { return }
        searchController.isActive = true
        searchController.searchBar.text = priorSearches[priorSearches.count - indexPath.row - 1]
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }
    
}
