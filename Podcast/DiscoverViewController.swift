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

    var trendingTopics = [Topic]()
    var topSeries = [Series]()
    var topEpisodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Discover"

        topEpisodesTableView = createEpisodesTableView()
        view.addSubview(topEpisodesTableView)
        topEpisodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodesReuseIdentifier)
        topEpisodesTableView.delegate = self
        topEpisodesTableView.dataSource = self
        topEpisodesTableView.tableHeaderView = headerView
        topEpisodesTableView.addInfiniteScroll { _ in
            self.fetchEpisodes()
        }
        topEpisodesTableView.snp.makeConstraints { make in
            make.edges.top.bottom.leading.trailing.equalToSuperview()
        }
        mainScrollView = topEpisodesTableView

        let discoverTopicsHeaderView = createCollectionHeaderView(type: .topics, tag: topicsHeaderTag)
        discoverTopicsHeaderView.delegate = self
        discoverTopicsHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        topTopicsCollectionView = createCollectionView(type: .discover)
        topTopicsCollectionView.register(TopicsGridCollectionViewCell.self, forCellWithReuseIdentifier: topicsReuseIdentifier)
        topTopicsCollectionView.dataSource = self
        topTopicsCollectionView.delegate = self
        topTopicsCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(topicsCollectionViewHeight)
            make.top.equalTo(discoverTopicsHeaderView.snp.bottom)
        }

        let topSeriesHeaderView = createCollectionHeaderView(type: .series, tag: seriesHeaderTag)
        topSeriesHeaderView.delegate = self
        topSeriesHeaderView.snp.makeConstraints { make in
            make.top.equalTo(topTopicsCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        topSeriesCollectionView = createCollectionView(type: .discover)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: seriesReuseIdentifier)
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(seriesCollectionViewHeight)
            make.top.equalTo(topSeriesHeaderView.snp.bottom)
        }

        let topEpisodesHeaderView = createCollectionHeaderView(type: .episodes, tag: episodesHeaderTag)
        topEpisodesHeaderView.snp.makeConstraints { make in
            make.top.equalTo(topSeriesCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        // adjust header height
        let headerViewHeight = 2 * headerHeight + seriesCollectionViewHeight + topicsCollectionViewHeight
        headerView.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        // dummy data
        let s = Series()
        s.title = "Design Details"
        topSeries = [s, s, s, s, s, s, s, s, s]
        let e = Episode()
        e.title = "Episode"
        topEpisodes = [e, e, e, e, e]
        topEpisodesTableView.reloadData()
        fetchDiscoverElements()
    }

    func fetchDiscoverElements() {
        let discoverSeriesEndpointRequest = DiscoverUserEndpointRequest(requestType: .series, offset: offset, max: pageSize)

        discoverSeriesEndpointRequest.success = { response in
            guard let series = response.processedResponseValue as? [Series] else { return }
            self.topSeries = series
            self.topSeriesCollectionView.reloadData()
        }

        let getAllTopicsEndpointRequest = GetAllTopicsEndpointRequest()

        getAllTopicsEndpointRequest.success = { response in
            guard let topics = response.processedResponseValue as? [Topic] else { return }
            self.trendingTopics = topics
            self.topTopicsCollectionView.reloadData()
        }

        System.endpointRequestQueue.addOperation(discoverSeriesEndpointRequest)
        System.endpointRequestQueue.addOperation(getAllTopicsEndpointRequest)

        fetchEpisodes()

    }

    func fetchEpisodes() {

        // todo: Delete this
        self.topEpisodesTableView.snp.makeConstraints { make in
            make.width.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.topSeriesCollectionView.snp.bottom)
            make.height.equalTo(self.topEpisodesTableView.contentSize.height)
        }

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
//            self.topEpisodesTableView.snp.makeConstraints { make in
//                make.width.bottom.equalToSuperview()
//                make.top.equalTo(self.topSeriesCollectionView.snp.bottom)
//                make.height.equalTo(self.topEpisodesTableView.contentSize.height)
//            }
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
            let vc = BrowseTopicsViewController()
            vc.topics = trendingTopics
            navigationController?.pushViewController(vc, animated: true)
        case seriesHeaderTag:
            let vc = BrowseSeriesViewController(mediaType: .user)
            vc.series = topSeries
            navigationController?.pushViewController(vc, animated: true)
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
        cell.setupWithEpisode(episode: topEpisodes[indexPath.row])
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
        appDelegate.showPlayer(animated: true)
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
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)

        var header: ActionSheetHeader?

        if let image = episodeTableViewCell.episodeSubjectView.podcastImage?.image, let title = episodeTableViewCell.episodeSubjectView.episodeNameLabel.text, let description = episodeTableViewCell.episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }

        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }

}
