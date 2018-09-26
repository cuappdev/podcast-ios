//
//  MainSearchViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/25/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchTableViewDelegate: class {
    func refreshController()
}

class MainSearchViewController: UIViewController {

    var searchController: UISearchController!
    var searchResultsTableView: UITableView!
    var tableViewData: MainSearchDataSourceDelegate!
    var searchDelayTimer: Timer?
    var searchText: String = ""

    var discoverContainerView: UIView!
    var discoverVC: DiscoverViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData = MainSearchDataSourceDelegate()
        tableViewData.delegate = self

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = false

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar")
            as? UIView else { return }
        statusBar.backgroundColor = .clear

        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.delegate = self
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white

        let searchField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchField?.textColor = .white
        searchField?.backgroundColor = #colorLiteral(red: 0.09749762056, green: 0.09749762056, blue: 0.09749762056, alpha: 1)

        navigationItem.titleView = searchController?.searchBar

        searchResultsTableView = UITableView(frame: .zero, style: .plain)
        searchResultsTableView.dataSource = tableViewData
        searchResultsTableView.delegate = tableViewData
        //swiftlint:disable:next line_length
        searchResultsTableView.register(PodcastTableViewCell.self, forCellReuseIdentifier: PodcastTableViewCell.cellReuseIdentifier)
        view.addSubview(searchResultsTableView)

        discoverContainerView = UIView()
        discoverContainerView.isUserInteractionEnabled = true
        view.addSubview(discoverContainerView)

        discoverVC = DiscoverViewController()
        addChildViewController(discoverVC)
        discoverContainerView.addSubview(discoverVC.view)

        makeConstraints()
    }

    func makeConstraints() {

        searchResultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        discoverContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        discoverVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainSearchViewController: SearchTableViewDelegate {

    func refreshController() {
        searchResultsTableView.reloadData()
        searchResultsTableView.layoutIfNeeded()
    }
}

// MARK: SearchBar Delegate
extension MainSearchViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        discoverContainerView.isHidden = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        discoverContainerView.isHidden = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        tableViewData.fetchData(query: searchText)
    }

}
