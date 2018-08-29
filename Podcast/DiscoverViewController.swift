//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/20/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DiscoverViewController: DiscoverComponentViewController {

    var trendingTopicsView: TrendingTopicsView!
    var topTopicsCollectionView: UICollectionView!
    var topSeriesCollectionView: UICollectionView!
    var topEpisodesTableView: UITableView!
    var currentlyPlayingIndexPath: IndexPath?

    let topicsReuseIdentifier = "topTopics"
    let seriesReuseIdentifier = "topSeries"
    let headerReuseIdentifier = "header"
    let episodesReuseIdentifier = "topEpisodes"
    let topicsHeaderTag = 1
    let seriesHeaderTag = 2
    let episodesHeaderTag = 3
    let topicsCollectionViewHeight: CGFloat = 110
    let seriesCollectionViewHeight: CGFloat = 160
    
    let episodesLoadingAnimationOffset: CGFloat = 60
    
    var topicsLoadingAnimation: NVActivityIndicatorView!
    var seriesLoadingAnimation: NVActivityIndicatorView!
    var episodesLoadingAnimation: NVActivityIndicatorView!

    override var pageSize: Int { get { return 10 } }

    var trendingTopics = [Topic]()
    var topSeries = [Series]()
    var topEpisodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Discover"

        topEpisodesTableView = createEpisodesTableView()
        topEpisodesTableView.delegate = self
        view.addSubview(topEpisodesTableView)
        topEpisodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodesReuseIdentifier)
        topEpisodesTableView.dataSource = self
        topEpisodesTableView.addInfiniteScroll { _ in
            self.fetchEpisodes()
        }
        topEpisodesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainScrollView = topEpisodesTableView

        topEpisodesTableView.tableHeaderView = headerView

        let discoverTopicsHeaderView = createCollectionHeaderView(type: .topics, tag: topicsHeaderTag)
        discoverTopicsHeaderView.delegate = self
        headerView.addSubview(discoverTopicsHeaderView)
        discoverTopicsHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        topTopicsCollectionView = createCollectionView(type: .discover)
        headerView.addSubview(topTopicsCollectionView)
        topTopicsCollectionView.register(TopicsGridCollectionViewCell.self, forCellWithReuseIdentifier: topicsReuseIdentifier)
        topTopicsCollectionView.dataSource = self
        topTopicsCollectionView.delegate = self
        topTopicsCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(topicsCollectionViewHeight)
            make.top.equalTo(discoverTopicsHeaderView.snp.bottom)
        }

        let topSeriesHeaderView = createCollectionHeaderView(type: .series, tag: seriesHeaderTag)
        headerView.addSubview(topSeriesHeaderView)
        topSeriesHeaderView.delegate = self
        topSeriesHeaderView.snp.makeConstraints { make in
            make.top.equalTo(topTopicsCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        topSeriesCollectionView = createCollectionView(type: .discover)
        headerView.addSubview(topSeriesCollectionView)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: seriesReuseIdentifier)
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(seriesCollectionViewHeight)
            make.top.equalTo(topSeriesHeaderView.snp.bottom)
        }

        let topEpisodesHeaderView = createCollectionHeaderView(type: .episodes, tag: episodesHeaderTag)
        headerView.addSubview(topEpisodesHeaderView)
        topEpisodesHeaderView.snp.makeConstraints { make in
            make.top.equalTo(topSeriesCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        // adjust header height
        let headerViewHeight = 3 * headerHeight + seriesCollectionViewHeight + topicsCollectionViewHeight
        headerView.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        topicsLoadingAnimation = LoadingAnimatorUtilities.createLoadingAnimator()
        view.addSubview(topicsLoadingAnimation)
        topicsLoadingAnimation.snp.makeConstraints { make in
            make.center.equalTo(topTopicsCollectionView.snp.center)
        }
        topicsLoadingAnimation.startAnimating()
        
        seriesLoadingAnimation = LoadingAnimatorUtilities.createLoadingAnimator()
        view.addSubview(seriesLoadingAnimation)
        seriesLoadingAnimation.snp.makeConstraints { make in
            make.center.equalTo(topSeriesCollectionView.snp.center)
        }
        seriesLoadingAnimation.startAnimating()
        
        episodesLoadingAnimation = LoadingAnimatorUtilities.createLoadingAnimator()
        view.addSubview(episodesLoadingAnimation)
        episodesLoadingAnimation.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(topEpisodesHeaderView.snp.bottom).offset(episodesLoadingAnimationOffset)
        }
        episodesLoadingAnimation.startAnimating()

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        fetchDiscoverElements()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topSeriesCollectionView.reloadData()
        topEpisodesTableView.reloadData()
        DownloadManager.shared.delegate = self
    }

    func fetchDiscoverElements(canPullToRefresh: Bool = false) {

        let discoverSeriesEndpointRequest = DiscoverUserEndpointRequest(requestType: .series, offset: 0, max: pageSize)

        discoverSeriesEndpointRequest.success = { response in
            guard let series = response.processedResponseValue as? [Series] else { return }
            self.topSeries = series
            self.topSeriesCollectionView.reloadData()
            self.seriesLoadingAnimation.stopAnimating()
        }

        let getAllTopicsEndpointRequest = GetAllTopicsEndpointRequest()

        getAllTopicsEndpointRequest.success = { response in
            guard let topics = response.processedResponseValue as? [Topic] else { return }
            self.trendingTopics = topics
            self.topTopicsCollectionView.reloadData()
            self.topicsLoadingAnimation.stopAnimating()
        }

        System.endpointRequestQueue.addOperation(discoverSeriesEndpointRequest)
        System.endpointRequestQueue.addOperation(getAllTopicsEndpointRequest)

        fetchEpisodes(canPullToRefresh: canPullToRefresh)

    }

    func fetchEpisodes(canPullToRefresh: Bool = false) {
        if canPullToRefresh {
            offset = 0
        }

        let getEpisodesEndpointRequest = DiscoverUserEndpointRequest(requestType: .episodes, offset: offset, max: pageSize)
        getEpisodesEndpointRequest.success = { response in
            guard let episodes = response.processedResponseValue as? [Episode] else { return }
            if episodes.isEmpty {
                self.continueInfiniteScroll = false
            }
            self.topEpisodes = canPullToRefresh ? episodes : self.topEpisodes + episodes
            self.offset += self.pageSize
            self.topEpisodesTableView.finishInfiniteScroll()
            self.topEpisodesTableView.reloadData()
            self.topEpisodesTableView.refreshControl?.endRefreshing()
            
            self.episodesLoadingAnimation.stopAnimating()
        }

        getEpisodesEndpointRequest.failure = { _ in
            self.topEpisodesTableView.finishInfiniteScroll()
        }

        System.endpointRequestQueue.addOperation(getEpisodesEndpointRequest)
    }

    override func handlePullToRefresh() {
        if let refreshControl = topEpisodesTableView.refreshControl {
            refreshControl.beginRefreshing()
            fetchDiscoverElements(canPullToRefresh: true)
        }
    }

}

// MARK: TrendingTopicsView Delegate
extension DiscoverViewController: TrendingTopicsViewDelegate {
    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        let topicViewController = DiscoverTopicViewController(topic: trendingTopics[indexPath.row])
        navigationController?.pushViewController(topicViewController, animated: true)
    }

}

// MARK: TopicsCollectionView Data Source
extension DiscoverViewController: TopicsCollectionViewDataSource {

    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return trendingTopics[index]
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return trendingTopics.count
    }

}

// MARK: CollectionView Delegate
extension DiscoverViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topTopicsCollectionView:
            return trendingTopics.count
        case topSeriesCollectionView:
            return topSeries.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topTopicsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topicsReuseIdentifier, for: indexPath) as? TopicsGridCollectionViewCell else { return TopicsGridCollectionViewCell() }
            cell.configure(for: trendingTopics[indexPath.row], at: indexPath.row)
            return cell
        case topSeriesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seriesReuseIdentifier, for: indexPath) as? SeriesGridCollectionViewCell else { return SeriesGridCollectionViewCell() }
            cell.configureForSeries(series: topSeries[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }

}

// MARK: CollectionView Data Source
extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case topTopicsCollectionView:
            let discoverTopicViewController = DiscoverTopicViewController(topic: trendingTopics[indexPath.row])
            navigationController?.pushViewController(discoverTopicViewController, animated: true)
        case topSeriesCollectionView:
            let seriesDetailViewController = SeriesDetailViewController()
            seriesDetailViewController.series = topSeries[indexPath.row]
            navigationController?.pushViewController(seriesDetailViewController, animated: true)
        default:
            return
        }
    }
}

// MARK: DiscoverTableViewHeader Delegate
extension DiscoverViewController: DiscoverTableViewHeaderDelegate {

    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeaderView) {
        switch sender.tag {
        case topicsHeaderTag:
            let browseTopicsViewController = BrowseTopicsViewController()
            browseTopicsViewController.topics = trendingTopics
            navigationController?.pushViewController(browseTopicsViewController, animated: true)
        case seriesHeaderTag:
            let browseSeriesViewController = BrowseSeriesViewController(mediaType: .user, series: topSeries)
            navigationController?.pushViewController(browseSeriesViewController, animated: true)
        default:
            break
        }
    }

}

// MARK: TableView Data Source
extension DiscoverViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: episodesReuseIdentifier) as? EpisodeTableViewCell else { return EpisodeTableViewCell() }
        cell.delegate = self
        let episode = topEpisodes[indexPath.row]
        cell.setup(with: episode, downloadStatus: DownloadManager.shared.status(for: episode.id))
        cell.layoutSubviews()
        if topEpisodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
        }
        return cell
    }

}

// MARK: TableView Delegate
extension DiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeDetailViewController = EpisodeDetailViewController()
        episodeDetailViewController.episode = topEpisodes[indexPath.row]
        navigationController?.pushViewController(episodeDetailViewController, animated: true)
    }
}

// MARK: EpisodeTableViewCell Delegate
extension DiscoverViewController: EpisodeTableViewCellDelegate {

    func didPress(on action: EpisodeAction, for cell: EpisodeTableViewCell) {
        guard let episodeIndexPath = topEpisodesTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = topEpisodes[episodeIndexPath.row]

        switch action {
        case .play:
            appDelegate.showAndExpandPlayer()
            Player.sharedInstance.playEpisode(episode: episode)
            cell.updateWithPlayButtonPress(episode: episode)
            
            // reset previously playings view
            if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = topEpisodesTableView.cellForRow(at: playingIndexPath) as? EpisodeTableViewCell {
                let playingEpisode = topEpisodes[playingIndexPath.row]
                currentlyPlayingCell.updateWithPlayButtonPress(episode: playingEpisode)
            }

            // update index path
            currentlyPlayingIndexPath = episodeIndexPath
        case .more:
            let downloadOption = ActionSheetOption(type: DownloadManager.shared.actionSheetType(for: episode.id), action: {
                DownloadManager.shared.handle(episode)
            })
            let shareEpisodeOption = ActionSheetOption(type: .shareEpisode, action: {
                guard let user = System.currentUser else { return }
                let viewController = ShareEpisodeViewController(user: user, episode: episode)
                self.navigationController?.pushViewController(viewController, animated: true)
            })

            var header: ActionSheetHeader?

            if let image = cell.episodeSubjectView.podcastImage?.image, let title = cell.episodeSubjectView.episodeNameLabel.text, let description = cell.episodeSubjectView.dateTimeLabel.text {
                header = ActionSheetHeader(image: image, title: title, description: description)
            }

            let actionSheetViewController = ActionSheetViewController(options: [downloadOption, shareEpisodeOption], header: header)
            showActionSheetViewController(actionSheetViewController: actionSheetViewController)
        case .bookmark:
            episode.bookmarkChange(completion: cell.setBookmarkButtonToState)
        case .recast:
            recast(for: episode, completion: {_,_ in
                cell.setup(with: episode, downloadStatus: DownloadManager.shared.status(for: episode.id))
            })
        }
    }
}

// MARK: Episode Downloader
extension DiscoverViewController: EpisodeDownloader {
    func didReceive(statusUpdate: DownloadStatus, for episode: Episode) {
        var paths: [IndexPath] = []
        for i in 0..<topEpisodes.count {
            if topEpisodes[i].id == episode.id {
                paths.append(IndexPath(row: i, section: 0))
            }
        }
        topEpisodesTableView.reloadRows(at: paths, with: .none)
    }
}
