//
//  SearchViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/30/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,  UISearchBarDelegate {

    var searchController: UISearchController!
    var results: [Episode] = []
    var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        
        // search
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        
        //tableview
        resultsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - tabBarController!.tabBar.frame.size.height))
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.backgroundColor = .podcastWhiteDark
        resultsTableView.separatorStyle = .none
        resultsTableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        view.addSubview(resultsTableView)
        resultsTableView.estimatedRowHeight = DiscoverTableViewCell().height
        resultsTableView.tableHeaderView = searchController.searchBar
        resultsTableView.reloadData()
        
        let series = Series()
        series.title = "Planet Money"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultsTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///
    /// MARK - table view
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCellIdentifier") as! DiscoverTableViewCell
        cell.episode = results[indexPath.row]

        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = resultsTableView.cellForRow(at: indexPath) as? DiscoverTableViewCell else { return }
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    ///
    /// MARK - search
    ///
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        resultsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultsTableView.reloadData()
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar.text
        
        if search == "" {
            return
        }
        
        //update search results here
        
        resultsTableView.reloadData()
    }
}
