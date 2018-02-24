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
        let fetchFeedEndpointRequest = FetchFeedEndpointRequest(maxtime: self.feedMaxTime, pageSize: pageSize)

        fetchFeedEndpointRequest.success = { (endpoint) in
            guard let feedElementsFromEndpoint = endpoint.processedResponseValue as? [FeedElement] else { return }
            for feedElement in feedElementsFromEndpoint {
                if case .followingShare = feedElement.context { // only add in the sharing feed elements
                    self.feedSet.insert(feedElement)
                }
            }

            self.feedElements = self.feedSet.sorted { (fe1,fe2) in fe1.time > fe2.time }
            if self.feedElements.count > 0 {
                self.feedMaxTime = Int(self.feedElements[self.feedElements.count - 1].time.timeIntervalSince1970)
            }
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

}

