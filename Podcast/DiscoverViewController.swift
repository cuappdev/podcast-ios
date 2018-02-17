//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/20/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

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
    let topicsCollectionViewHeight: CGFloat = 165
    let seriesCollectionViewHeight: CGFloat = 200

    var trendingTopics = [Topic]()
    var topSeries = [Series]()
    var topEpisodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Discover"

        topTopicsCollectionView = createCollectionView(with: .discover)
        topTopicsCollectionView.register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        topTopicsCollectionView.register(TopicsGridCollectionViewCell.self, forCellWithReuseIdentifier: topicsReuseIdentifier)
        topTopicsCollectionView.delegate = self
        topTopicsCollectionView.dataSource = self

        topTopicsCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(topicsCollectionViewHeight)
            make.top.equalToSuperview()
        }

        topSeriesCollectionView = createCollectionView(with: .discover)
        topSeriesCollectionView.register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: seriesReuseIdentifier)
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(seriesCollectionViewHeight)
            make.top.equalTo(topTopicsCollectionView.snp.bottom)
        }

        topEpisodesTableView = createEpisodesTableView()
        topEpisodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodesReuseIdentifier)
        topEpisodesTableView.delegate = self
        topEpisodesTableView.dataSource = self

//        trendingTopics = [Topic(name: "Arts"), Topic(name:"Business"), Topic(name:"Government & Organizations"), Topic(name:"Religion & Spirituality"), Topic(name: "Kids & Family"), Topic(name: "Technology")]
        let s = Series()
        s.title = "Design Details"
        topSeries = [s, s, s, s, s, s, s, s, s]
        let e = Episode()
        e.title = "Episode"
        topEpisodes = [e, e, e, e, e]
        topEpisodesTableView.reloadData()
        topEpisodesTableView.snp.makeConstraints { make in
            make.width.bottom.equalToSuperview()
            make.top.equalTo(topSeriesCollectionView.snp.bottom)
            make.height.equalTo(topEpisodesTableView.contentSize.height)
        }
        fetchDiscoverElements()

    }

    func fetchDiscoverElements() {
        let discoverSeriesEndpointRequest = DiscoverUserEndpointRequest(requestType: .series)

        discoverSeriesEndpointRequest.success = { response in
            guard let series = response.processedResponseValue as? [Series] else { return }
            self.topSeries = series
            self.topSeriesCollectionView.reloadData()
        }

        discoverSeriesEndpointRequest.failure = { _ in

        }

        let getAllTopicsEndpointRequest = GetAllTopicsEndpointRequest()

        getAllTopicsEndpointRequest.success = { response in
            guard let topics = response.processedResponseValue as? [Topic] else { return }
            self.trendingTopics = topics
            self.topTopicsCollectionView.reloadData()
        }

        getAllTopicsEndpointRequest.failure = { _ in
        }

        System.endpointRequestQueue.addOperation(getAllTopicsEndpointRequest)
//        System.endpointRequestQueue.addOperation(discoverSeriesEndpointRequest)

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
        // TODO
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
        // WHY ISN'T THIS WORKING??
        switch collectionView {
        case topTopicsCollectionView:
            let discoverTopicViewController = DiscoverTopicViewController()
            navigationController?.pushViewController(discoverTopicViewController, animated: true)
        case topSeriesCollectionView:
            let seriesDetailViewController = SeriesDetailViewController(series: topSeries[indexPath.row])
            navigationController?.pushViewController(seriesDetailViewController, animated: true)
        default:
            return
        }
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? DiscoverCollectionViewHeader else { return DiscoverCollectionViewHeader() }
        header.delegate = self
        switch collectionView {
        case topTopicsCollectionView:
            header.tag = topicsHeaderTag
            header.configure(sectionType: .topics)
            return header
        case topSeriesCollectionView:
            header.tag = seriesHeaderTag
            header.configure(sectionType: .series)
            return header
        default:
            return header
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }

}

// MARK: - Discover Header
extension DiscoverViewController: DiscoverTableViewHeaderDelegate {

    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeader) {
        switch sender.tag {
        case topicsHeaderTag:
            let vc = BrowseTopicsViewController()
            vc.topics = trendingTopics
            navigationController?.pushViewController(vc, animated: true)
        case seriesHeaderTag:
            let vc = BrowseSeriesViewController()
            vc.series = topSeries
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("error")
        }
    }

}

// MARK: Table View
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
