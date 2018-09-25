//
//  DiscoverViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class DiscoverViewController: UIViewController {

    // MARK: - Variables
    var searchController: UISearchController!
    var tableViewHeader: DiscoverTableViewHeader!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .black

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar")
            as? UIView else { return }
        statusBar.backgroundColor = .black

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = .black

        navigationItem.titleView = searchController?.searchBar

        tableViewHeader = DiscoverTableViewHeader(frame: .zero)
        tableViewHeader.isUserInteractionEnabled = true
        view.addSubview(tableViewHeader)

        makeConstraints()
    }

    func makeConstraints() {
        tableViewHeader.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
