//
//  DiscoverComponentViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 2/7/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class DiscoverComponentViewController: ViewController {

    var scrollView: ScrollView!
    var contentView: UIView!

    let headerHeight: CGFloat = 60
    let estimatedRowHeight: CGFloat = 150

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        edgesForExtendedLayout = []

        scrollView = ScrollView(frame: view.frame)
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainScrollView = scrollView

        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    func createCollectionView(with type: CollectionLayoutType) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout(layoutType: type))
        collectionView.backgroundColor = .paleGrey
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)

        return collectionView
    }

    func createEpisodesTableView() -> UITableView {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .paleGrey
        let header = DiscoverCollectionViewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        header.backgroundColor = .paleGrey
        header.configure(sectionType: .episodes)
        tableView.tableHeaderView = header
        contentView.addSubview(tableView)

        return tableView
    }

}
