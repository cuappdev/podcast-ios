//
//  SearchITunesTableViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/3/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchITunesTableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, SearchSeriesTableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var searchResults: [Series] = []
    let seriesCellIdentifier = "SeriesCell"
    let seriesCellHeight: CGFloat = 95
    
    var loadingIndicatorView: NVActivityIndicatorView?
    var tableView: EmptyStateTableView = EmptyStateTableView(frame: .zero, type: .search)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.frame
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        mainScrollView = tableView
        
        loadingIndicatorView = createLoadingAnimationView()
        view.addSubview(loadingIndicatorView!)
        loadingIndicatorView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    func fetchData(query: String, completion: (() -> ())?)  {
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchEpisodesEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchUsersEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchSeriesEndpointRequest.self)
        
        tableView.backgroundView?.isHidden = true
        loadingIndicatorView?.startAnimating()
        
        let request = SearchITunesEndpointRequest(query: query, offset: 0, max: 20)
        request.success = { request in
            guard let results = request.processedResponseValue as? [Series] else { return }
            if results.isEmpty {
                self.tableView.backgroundView?.isHidden = false
            }
            self.searchResults = results
            self.tableView.reloadData()
            self.loadingIndicatorView?.stopAnimating()
        }
        request.failure = { request in
            self.tableView.backgroundView?.isHidden = false
            self.loadingIndicatorView?.stopAnimating()
        }
        System.endpointRequestQueue.addOperation(request)
        completion?()
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return seriesCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: seriesCellIdentifier) as? SearchSeriesTableViewCell {
            cell.configure(for: searchResults[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        }
        let seriesCell = SearchSeriesTableViewCell(style: .default, reuseIdentifier: seriesCellIdentifier)
        seriesCell.configure(for: searchResults[indexPath.row], index: indexPath.row)
        seriesCell.delegate = self
        return seriesCell
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
        fetchData(query: searchText, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.backgroundView?.isHidden = true
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        tableView.backgroundView?.isHidden = true
    }
    
    // MARK: SearchSeriesCellDelegate
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let series = searchResults[indexPath.row]
        series.subscriptionChange(completion: cell.setSubscribeButtonToState(isSubscribed:numberOfSubscribers:))
    }

}
