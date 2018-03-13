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

    var headerView: UIView!

    let headerHeight: CGFloat = 60
    let estimatedRowHeight: CGFloat = 200

    let pageSize = 20
    var offset = 0
    var continueInfiniteScroll = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        edgesForExtendedLayout = []

        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }

    func createCollectionView(type: CollectionLayoutType) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout(layoutType: type))
        collectionView.backgroundColor = .paleGrey
        collectionView.showsHorizontalScrollIndicator = false

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
        return header
    }

}
