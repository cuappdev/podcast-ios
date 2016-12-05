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
    
    /* Throttled search updates */
    func updateSearchResults(for searchController: UISearchController) {
        /* Cancel previous request (if any) */
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(populateSearchResults), object: nil)
        /* Throttle */
        perform(#selector(populateSearchResults), with: nil, afterDelay: 1.0)
    }
    
    /* Populate the search results */
    func populateSearchResults () {
        let query = searchController.searchBar.text
        if query == "" { return }
        REST.searchEverything(query: query!) { (data, error) in
            self.results = []
            let eps = data["episodes"].array!
            for e in eps {
                let newEp = Episode(id: 0, title: e["title"].string!, dateCreated: Date(), descriptionText: e["description"].string!, smallArtworkImage: #imageLiteral(resourceName: "fillerImage"), largeArtworkImage: #imageLiteral(resourceName: "fillerImage"),
                                    mp3URL: e["audio_url"].string!)
                self.results.append(newEp)
                // Play song stuff
            }
            self.resultsTableView.reloadData()
        }
    }
    
}
