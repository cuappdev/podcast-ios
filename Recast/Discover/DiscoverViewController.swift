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

    var searchResultsViewController: UITableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.09749762056, green: 0.09749762056, blue: 0.09749762056, alpha: 1)

        tableViewHeader = DiscoverTableViewHeader(frame: .zero)
        view.addSubview(tableViewHeader)

        makeConstraints()
    }

    func makeConstraints() {
        tableViewHeader.snp.makeConstraints { make in
            //it was all in the console. It told me the height was ambigious
            make.height.lessThanOrEqualToSuperview()
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}