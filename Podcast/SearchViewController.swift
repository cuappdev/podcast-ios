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

    var searchController: UISearchController!
    var searchResultsController: TabbedPageViewController!
    var pastSearchesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        
        searchResultsController = TabbedPageViewController()
        searchResultsController.searchResultsDelegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController

        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.sea]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey: Any], for: .normal)
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search"
        navigationItem.titleView = searchController.searchBar
        searchResultsController.searchBarY = searchController.searchBar.frame.maxY
        
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        pastSearchesTableView = UITableView(frame: CGRect.zero)
        pastSearchesTableView.register(PastSearchTableViewCell.self, forCellReuseIdentifier: "PastSearchCell")
        pastSearchesTableView.delegate = self
        pastSearchesTableView.dataSource = self
        pastSearchesTableView.separatorStyle = .none
        view.addSubview(pastSearchesTableView)
        
        pastSearchesTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(self.navigationController?.navigationBar.frame.height ?? 0)
            make.height.equalToSuperview()
        }
    }
    
    //MARK: - Tabbed Search Results Delegate
    func didTapOnSeriesCell(series: Series) {
        if let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String], let text = searchController.searchBar.text {
            UserDefaults.standard.set(pastSearches + [text], forKey: "PastSearches")
        } else if let text = searchController.searchBar.text  {
            UserDefaults.standard.set([text], forKey: "PastSearches")
        }
        let seriesDetailViewController = SeriesDetailViewController(series: series)
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }
    
    func didTapOnTagCell(tag: Tag) {
        let tagViewController = TagViewController()
        tagViewController.tag = tag
        navigationController?.pushViewController(tagViewController, animated: true)
    }
    
    func didTapOnEpisodeCell(episode: Episode) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }

    //MARK: -
    //MARK: UITableViewDelegate & Data source
    //MARK: -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PastSearchCell") as? PastSearchTableViewCell else { return UITableViewCell() }
        guard let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String] else {
            cell.configureNoPastSearches()
            return cell
        }
        cell.label.text = pastSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String] {
            return pastSearches.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PastSearchTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String] else { return }
        searchController.isActive = true
        searchController.searchBar.text = pastSearches[indexPath.row]
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }
    
}
