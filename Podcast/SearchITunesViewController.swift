//
//  SearchITunesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class SearchITunesViewController: ViewController {
    
    var searchController: UISearchController!
    var searchResultsController: SearchITunesTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Search iTunes"
        
        searchResultsController = SearchITunesTableViewController()
        view.addSubview(searchResultsController.view)
        
        searchController = UISearchController(searchResultsController: searchResultsController)

        let topBarAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.sea]
        UIBarButtonItem.appearance().setTitleTextAttributes(topBarAttributes as? [NSAttributedStringKey: Any], for: .normal)
        navigationController?.navigationBar.tintColor = .sea
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.showsSearchResultsButton = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = searchResultsController
        searchController.delegate = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            searchResultsController.tableView.tableHeaderView = searchController.searchBar
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController?.searchBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
