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
        view.addSubview(topEpisodesTableView)
        topEpisodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodesReuseIdentifier)
        topEpisodesTableView.delegate = self
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
        fetchDiscoverElements()
    }

    func fetchDiscoverElements() {
        topSeriesCollectionView.reloadData()

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

        fetchEpisodes()

    }

    func fetchEpisodes() {
        
        let getEpisodesEndpointRequest = DiscoverUserEndpointRequest(requestType: .episodes, offset: offset, max: pageSize)
        getEpisodesEndpointRequest.success = { response in
            guard let episodes = response.processedResponseValue as? [Episode] else { return }
            if episodes.count == 0 {
                self.continueInfiniteScroll = false
            }
            self.topEpisodes = self.topEpisodes + episodes
            self.offset += self.pageSize
            self.topEpisodesTableView.finishInfiniteScroll()
            self.topEpisodesTableView.reloadData()
            self.episodesLoadingAnimation.stopAnimating()
        }

        getEpisodesEndpointRequest.failure = { _ in
            self.topEpisodesTableView.finishInfiniteScroll()
        }

        System.endpointRequestQueue.addOperation(getEpisodesEndpointRequest)
    }

}

// MARK: - Trending Topics
extension DiscoverViewController: TrendingTopicsViewDelegate, TopicsCollectionViewDataSource {
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return trendingTopics[index]
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return trendingTopics.count
    }

    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        let topicViewController = DiscoverTopicViewController(topic: trendingTopics[indexPath.row])
        navigationController?.pushViewController(topicViewController, animated: true)
    }

}

// MARK: - Collection View
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - Discover Header
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

// MARK: - Table View
extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: episodesReuseIdentifier) as? EpisodeTableViewCell else { return EpisodeTableViewCell() }
        cell.delegate = self
        cell.setup(with: topEpisodes[indexPath.row])
        cell.layoutSubviews()
        if topEpisodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeDetailViewController = EpisodeDetailViewController()
        episodeDetailViewController.episode = topEpisodes[indexPath.row]
        navigationController?.pushViewController(episodeDetailViewController, animated: true)
    }
}

// MARK: - Episode Table View Cells
extension DiscoverViewController: EpisodeTableViewCellDelegate {
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = topEpisodesTableView.indexPath(for: episodeTableViewCell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = topEpisodes[episodeIndexPath.row]
        appDelegate.showAndExpandPlayer()
        Player.sharedInstance.playEpisode(episode: episode)
        episodeTableViewCell.updateWithPlayButtonPress(episode: episode)

        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = topEpisodesTableView.cellForRow(at: playingIndexPath) as? EpisodeTableViewCell {
            let playingEpisode = topEpisodes[playingIndexPath.row]
            currentlyPlayingCell.updateWithPlayButtonPress(episode: playingEpisode)
        }

        // update index path
        currentlyPlayingIndexPath = episodeIndexPath
    }

    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = topEpisodesTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = topEpisodes[episodeIndexPath.row]
        episode.recommendedChange(completion: episodeTableViewCell.setRecommendedButtonToState)
    }

    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = topEpisodesTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = topEpisodes[episodeIndexPath.row]
        episode.bookmarkChange(completion: episodeTableViewCell.setBookmarkButtonToState)
    }

    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = topEpisodesTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = topEpisodes[episodeIndexPath.row]

        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: {
            DownloadManager.shared.downloadOrRemove(episode: episode, callback: self.didReceiveDownloadUpdateFor)
        })
        let shareEpisodeOption = ActionSheetOption(type: .shareEpisode, action: {
            guard let user = System.currentUser else { return }
            let viewController = ShareEpisodeViewController(user: user, episode: episode)
            self.navigationController?.pushViewController(viewController, animated: true)
        })

        var header: ActionSheetHeader?

        if let image = episodeTableViewCell.episodeSubjectView.podcastImage?.image, let title = episodeTableViewCell.episodeSubjectView.episodeNameLabel.text, let description = episodeTableViewCell.episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }

        let actionSheetViewController = ActionSheetViewController(options: [option1, shareEpisodeOption], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }

    func didReceiveDownloadUpdateFor(episode: Episode) {
        var paths: [IndexPath] = []
        for i in 0..<topEpisodes.count {
            if topEpisodes[i].id == episode.id {
                paths.append(IndexPath(row: i, section: 0))
            }
        }
        topEpisodesTableView.reloadRows(at: paths, with: .none)
    }
}
