//
//  SearchITunesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class SearchITunesViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, SearchSeriesTableViewDelegate, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var tableView: EmptyStateTableView!
    var initialQuery: String!
    
    var searchResults: [Series] = []
    let seriesCellIdentifier = "SeriesCell"
    let seriesCellHeight: CGFloat = 95

    convenience init(query: String) {
        self.init()
        initialQuery = query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Search iTunes"
        
        tableView = EmptyStateTableView(frame: view.frame, type: .search)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.stopLoadingAnimation()
        tableView.backgroundView?.isHidden = true
        view.addSubview(tableView)
        mainScrollView = tableView
        
        let topBarAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.sea]
        UIBarButtonItem.appearance().setTitleTextAttributes(topBarAttributes as? [NSAttributedStringKey: Any], for: .normal)
        navigationController?.navigationBar.tintColor = .sea
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = .offWhite
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.showsSearchResultsButton = false
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.text = initialQuery
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func fetchData(query: String)  {
        searchResults = []
        tableView.reloadData()
        tableView.startLoadingAnimation()
        tableView.backgroundView?.isHidden = false
        
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchITunesEndpointRequest.self)
        let request = SearchITunesEndpointRequest(query: query)
        request.success = { request in
            guard let results = request.processedResponseValue as? [Series] else { return }
            if results.isEmpty {
                self.tableView.backgroundView?.isHidden = false
            }
            self.searchResults = results
            self.tableView.stopLoadingAnimation()
            self.tableView.reloadData()
        }
        request.failure = { _ in
            self.tableView.backgroundView?.isHidden = false
            self.tableView.stopLoadingAnimation()
        }
        System.endpointRequestQueue.addOperation(request)
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return seriesCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchSeriesTableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: seriesCellIdentifier) as? SearchSeriesTableViewCell {
            cell = dequeuedCell
        } else {
            cell = SearchSeriesTableViewCell(style: .default, reuseIdentifier: seriesCellIdentifier)
        }
        cell.configure(for: searchResults[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController(series: searchResults[indexPath.row])
        navigationController?.pushViewController(seriesDetailViewController,animated: true)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        fetchData(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: SearchSeriesCellDelegate
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let series = searchResults[indexPath.row]
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
