//
//  SearchITunesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class SearchITunesViewController: ViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, SearchSeriesTableViewDelegate {

    let seriesCellIdentifier = "SeriesCell"
    let seriesCellHeight: CGFloat = 95
    
    var cellDelegate: SearchTableViewControllerDelegate?
    
    var loadingIndicatorView: NVActivityIndicatorView?
    var tableView: EmptyStateTableView = EmptyStateTableView(withType: .search)
    var searchController: UISearchController!

    var searchResults: [Series] = []
    
    var currentlyPlayingIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.setRightBarButton(dismissBarButtonItem, animated: true)
        tableView.frame = view.frame
        tableView.backgroundView?.isHidden = true
        tableView.register(SearchSeriesTableViewCell.self, forCellReuseIdentifier: seriesCellIdentifier)
        tableView.frame = view.frame
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.sea]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey: Any], for: .normal)
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search iTunes"
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        
        loadingIndicatorView = createLoadingAnimationView()
        view.addSubview(loadingIndicatorView!)
        
        loadingIndicatorView!.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mainScrollView = tableView
        automaticallyAdjustsScrollViewInsets = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = currentlyPlayingIndexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchEpisodeTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = nil
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchData(query: String, completion: (() -> ())?)  {
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchEpisodesEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchUsersEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchSeriesEndpointRequest.self)
        
        tableView.backgroundView?.isHidden = false
        loadingIndicatorView?.startAnimating()
        
        let request = SearchSeriesEndpointRequest(query: query, offset: 0, max: 20)
        request.success = { request in
            guard let results = request.processedResponseValue as? [Series] else { return }
            if results.isEmpty {
                return
            }
            self.searchResults = results
            self.tableView.reloadData()
            self.loadingIndicatorView?.stopAnimating()
        }
        request.failure = { request in
            self.tableView.backgroundView?.isHidden = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: seriesCellIdentifier) as? SearchSeriesTableViewCell else { return UITableViewCell() }
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
    
    // MARK: UISearchControllerDelegate
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        fetchData(query: searchText, completion: nil)
    }
    
    // MARK: SearchSeriesCellDelegate
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let series = searchResults[indexPath.row]
        series.isSubscribed = !series.isSubscribed
        if series.isSubscribed {
            let createSubscriptionEndpointRequest = CreateUserSubscriptionEndpointRequest(seriesID: series.seriesId)
            createSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                series.didSubscribe()
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            createSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = false
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(createSubscriptionEndpointRequest)
        } else {
            let deleteSubscriptionEndpointRequest = DeleteUserSubscriptionEndpointRequest(seriesID: String(series.seriesId))
            deleteSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                series.didUnsubscribe()
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            deleteSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = true
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(deleteSubscriptionEndpointRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
