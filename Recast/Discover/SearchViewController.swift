//
//  SearchViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/25/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var searchController: UISearchController!
    var searchResultsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .black

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar")
            as? UIView else { return }
        statusBar.backgroundColor = .clear

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = .black
        navigationItem.titleView = searchController?.searchBar

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false

        searchResultsTableView = UITableView(frame: .zero, style: .plain)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
    }

}

// MARK: - Search UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }


}

// MARK: - Search UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

}

// MARK: UISearchController Delegate
extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {

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
