//
//  DiscoverComponentViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 2/7/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

/// ViewController helper subclass that creates the main UI components of the Discover user and topic views.
class DiscoverComponentViewController: ViewController, NVActivityIndicatorViewable {

    var scrollView: ScrollView!
    var contentView: UIView!

    let headerHeight: CGFloat = 60
    let estimatedRowHeight: CGFloat = 225

    let pageSize = 10
    var offset = 0
    var continueInfiniteScroll = true

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
            make.edges.width.top.bottom.equalToSuperview()
        }
    }

    func createCollectionView(type: CollectionLayoutType) -> UICollectionView {
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
        tableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        let header = DiscoverCollectionViewHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        header.backgroundColor = .paleGrey
        header.configure(sectionType: .episodes)
        tableView.tableHeaderView = header
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        contentView.addSubview(tableView)

        return tableView
    }

    func createCollectionHeaderView(type: DiscoverHeaderType, tag: Int) -> DiscoverCollectionViewHeaderView {
        let headerView = DiscoverCollectionViewHeaderView(frame: .zero)
        headerView.configure(sectionType: type)
        headerView.tag = tag
        contentView.addSubview(headerView)
        
        return headerView
    }

}
