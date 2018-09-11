//
//  BrowseSeriesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 12/28/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

/// Represents which type of series content to display in the BrowseSeriesViewController.
enum BrowseSeriesMediaType {
    case user
    case topic(id: Int)
}

/// Displays a list of series from the DiscoverViewController.
class BrowseSeriesViewController: ViewController, NVActivityIndicatorViewable {

    let reuseIdentifier = "Reuse"
    let rowHeight: CGFloat = 95

    var series: [Series] = []
    var seriesTableView: UITableView!
    var loadingAnimator: NVActivityIndicatorView?

    var continueInfiniteScroll = true
    let pageSize = 40
    var offset = 0

    var mediaType: BrowseSeriesMediaType

    init(mediaType: BrowseSeriesMediaType, series: [Series]) {
        self.mediaType = mediaType
        self.series = series
        self.offset = series.count
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = "Series"
        seriesTableView = UITableView(frame: .zero, style: .plain)
        seriesTableView.tableFooterView = UIView()
        seriesTableView.register(SearchSeriesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        seriesTableView.delegate = self
        seriesTableView.dataSource = self
        seriesTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        seriesTableView.infiniteScrollTriggerOffset = view.frame.height * 0.25 // prefetch next page when you're 75% down the page
        seriesTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        seriesTableView.addInfiniteScroll { _ in
            self.fetchSeries()
        }
        mainScrollView = seriesTableView
        view.addSubview(seriesTableView)
        seriesTableView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
        offset = series.count

        // if the user immediately tries to click "Browse Series", nothing will show up: load series here
        if offset == 0 {
            fetchSeries()
            loadingAnimator = LoadingAnimatorUtilities.createLoadingAnimator()
            view.addSubview(loadingAnimator!) // force unwrapped because we just created it
            loadingAnimator?.snp.makeConstraints({ make in
                make.center.equalToSuperview()
            })
            loadingAnimator?.startAnimating()
        }
        seriesTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        seriesTableView.reloadData()
    }

    func fetchSeries() {
        var getSeriesEndpointRequest: EndpointRequest

        switch mediaType {
        case BrowseSeriesMediaType.user:
            getSeriesEndpointRequest = DiscoverUserEndpointRequest(requestType: .series, offset: offset, max: pageSize)

        case BrowseSeriesMediaType.topic(let id):
            getSeriesEndpointRequest = DiscoverTopicEndpointRequest(requestType: .series, topicID: id, offset: offset, max: pageSize)
        }

        getSeriesEndpointRequest.success = { response in
            guard let series = response.processedResponseValue as? [Series] else { return }
            if series.isEmpty {
                self.continueInfiniteScroll = false
            }
            self.series = self.series + series
            self.offset += self.pageSize
            self.seriesTableView.finishInfiniteScroll()
            self.seriesTableView.reloadData()
            self.loadingAnimator?.stopAnimating()
        }

        getSeriesEndpointRequest.failure = { _ in
            self.seriesTableView.finishInfiniteScroll()
        }

        System.endpointRequestQueue.addOperation(getSeriesEndpointRequest)

    }

}

// MARK: TableView Data Source
extension BrowseSeriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SearchSeriesTableViewCell else { return SearchSeriesTableViewCell() }
        let seriesAtIndex = series[indexPath.row]
        cell.displayView.set(title: seriesAtIndex.title)
        cell.displayView.set(author: seriesAtIndex.author)
        cell.displayView.set(numberOfSubscribers: seriesAtIndex.numberOfSubscribers, isSubscribed: seriesAtIndex.isSubscribed)
        if let url = seriesAtIndex.smallArtworkImageURL {
            cell.displayView.set(smallImageUrl: url)
        }
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

}

// MARK: TableView Delegate
extension BrowseSeriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController(series: series[indexPath.row])
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
}

// MARK: SearchSeriesTableView Delegate
extension BrowseSeriesViewController: SearchSeriesTableViewDelegate {
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = seriesTableView.indexPath(for: cell) else { return }
        let series = self.series[indexPath.row]
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }
}
