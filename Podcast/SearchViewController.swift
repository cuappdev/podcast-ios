//
//  SearchViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/30/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,  UISearchBarDelegate {

    var searchBar: UISearchBar!
    var results: [Episode] = []
    var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark

        // search
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
//        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        self.definesPresentationContext = true
        
        //tableview
        resultsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.backgroundColor = .podcastWhiteDark
        resultsTableView.separatorStyle = .none
        resultsTableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        view.addSubview(resultsTableView)
        resultsTableView.estimatedRowHeight = DiscoverTableViewCell().height
        resultsTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsTableView.reloadData()
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        perform(#selector(populateSearchResults), with: nil, afterDelay: 0.5)
    }
    
    /* Populate the search results */
    func populateSearchResults () {
        guard let query = searchBar.text, query != "" else { return }

        let searchEndpointRequest = SearchEndpointRequest(query: query.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
        
        searchEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                if let results = endpointRequest.processedResponseValue as? [Episode] {
                    self.results = results
                    self.resultsTableView.reloadData()
                }
            }
        }

        EndpointRequestQueue.shared.addOperation(searchEndpointRequest)
    }
    
}
