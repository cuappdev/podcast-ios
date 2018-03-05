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
    var headerView: UIView!

    let headerHeight: CGFloat = 60
    let estimatedRowHeight: CGFloat = 200

    let pageSize = 10
    var offset = 0
    var continueInfiniteScroll = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        edgesForExtendedLayout = []

        headerView = UIView(frame: .zero)

//        scrollView = ScrollView(frame: view.frame)
//        scrollView.showsHorizontalScrollIndicator = false
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        mainScrollView = scrollView
//
//        contentView = UIView()
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.edges.width.top.bottom.equalToSuperview()
//        }
    }

    func createCollectionView(type: CollectionLayoutType) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout(layoutType: type))
        collectionView.backgroundColor = .paleGrey
        collectionView.showsHorizontalScrollIndicator = false
        headerView.addSubview(collectionView)

        return collectionView
    }

    func createEpisodesTableView() -> UITableView {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = .paleGrey
        tableView.showsVerticalScrollIndicator = false
        tableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        tableView.tableHeaderView = headerView
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        view.addSubview(tableView)

        return tableView
    }

    func createCollectionHeaderView(type: DiscoverHeaderType, tag: Int) -> DiscoverCollectionViewHeaderView {
        let header = DiscoverCollectionViewHeaderView(frame: .zero)
        header.configure(sectionType: type)
        header.tag = tag
        headerView.addSubview(header)
        return header
    }

}
