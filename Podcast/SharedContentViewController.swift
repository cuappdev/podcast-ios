//
//  SharedContentViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/15/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

/// View Controller showing all content personally shared with you by other users
// TODO: refactor later on, quick hack for MVP
class SharedContentViewController: FeedViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        emptyStateViewType = .sharedContent
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shared With You"
    }

    // TODO: replace with fetch shared endpoint 
    override func fetchFeedElements(isPullToRefresh: Bool = true) {
        let fetchFeedEndpointRequest = FetchSharesEndpointRequest(offset: isPullToRefresh ? 0 : feedElements.count, max: pageSize)

        fetchFeedEndpointRequest.success = { (endpoint) in
            guard let feedElementsFromEndpoint = endpoint.processedResponseValue as? [FeedElement] else { return }
            for feedElement in feedElementsFromEndpoint {
                self.feedSet.insert(feedElement)
            }

            self.feedElements = self.feedSet.sorted { (fe1,fe2) in fe1.time > fe2.time }

            if !isPullToRefresh {
                if self.feedElements.count < self.pageSize {
                    self.continueInfiniteScroll = false
                }
            }

            self.feedTableView.endRefreshing()
            self.feedTableView.stopLoadingAnimation()
            self.feedTableView.finishInfiniteScroll()
            self.feedTableView.reloadData()
        }

        fetchFeedEndpointRequest.failure = { _ in
            self.feedTableView.stopLoadingAnimation()
            self.feedTableView.endRefreshing()
            self.feedTableView.finishInfiniteScroll()
            self.feedTableView.reloadData()
        }

        System.endpointRequestQueue.addOperation(fetchFeedEndpointRequest)
    }

    // overrode this function because endpoint have sharer / sharee but no is_following field, thus we need to call ExternalProfile's fetchUser
    override func didPress(userSeriesSupplierView: UserSeriesSupplierView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell) else { return }

        let supplier = feedElements[indexPath.row].context.supplier
        if let user = supplier as? User {
            let profileViewController = UserDetailViewController(user: user)
            navigationController?.pushViewController(profileViewController, animated: true)
        } else if let series = supplier as? Series {
            let seriesDetailViewController = SeriesDetailViewController(series: series)
            navigationController?.pushViewController(seriesDetailViewController, animated: true)
        }
    }
}

