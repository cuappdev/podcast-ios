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
    func didPress(_ partialPodcast: PartialPodcast)
}

class MainSearchViewController: ViewController {

    // MARK: - Variables
    var searchController: UISearchController!
    var searchResultsTableView: UITableView!
    var tableViewData: MainSearchDataSourceDelegate!
    var searchDelayTimer: Timer?
    var searchText: String = ""

    var discoverContainerView: UIView!
    var discoverVC: DiscoverViewController!

    // MARK: - Constants
    let podcastCellReuseId = PodcastTableViewCell.cellReuseId

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"

        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        let searchField = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        searchField?.textColor = .white
        searchField?.backgroundColor = #colorLiteral(red: 0.09749762056, green: 0.09749762056, blue: 0.09749762056, alpha: 1)

        searchController?.searchBar.barTintColor = .black
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.tintColor = .white
        navigationItem.titleView = searchController.searchBar

        tableViewData = MainSearchDataSourceDelegate()
        tableViewData.delegate = self

        searchResultsTableView = UITableView(frame: .zero, style: .plain)
        searchResultsTableView.dataSource = tableViewData
        searchResultsTableView.delegate = tableViewData
        searchResultsTableView.register(PodcastTableViewCell.self, forCellReuseIdentifier: podcastCellReuseId)
        view.addSubview(searchResultsTableView)

        discoverContainerView = UIView()
        discoverContainerView.isUserInteractionEnabled = true
        view.addSubview(discoverContainerView)

        discoverVC = DiscoverViewController()
        addChild(discoverVC)
        discoverContainerView.addSubview(discoverVC.view)

        setUpConstraints()
    }

    func setUpConstraints() {
        searchResultsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        discoverContainerView.snp.makeConstraints { make in
            make.edges.equalTo(searchResultsTableView)
        }
        discoverVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        searchController.searchBar.delegate = self
    }
}

// MARK: - searchResultsTableView Delegate
extension MainSearchViewController: SearchTableViewDelegate {
    func refreshController() {
        searchResultsTableView.reloadData()
        searchResultsTableView.layoutIfNeeded()
    }

    func didPress(_ partialPodcast: PartialPodcast) {
        let podcastDetailVC = PodcastDetailViewController(partialPodcast: partialPodcast)
        navigationController?.pushViewController(podcastDetailVC, animated: true)
    }
}

// MARK: UISearchBarDelegate
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
