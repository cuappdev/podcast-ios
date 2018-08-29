//
//  DiscoverTopicViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

/// Displays the discoverable content (series, episodes) for a given topic. 
class DiscoverTopicViewController: DiscoverComponentViewController {

    override var usesLargeTitles: Bool { get { return false } }

    var relatedTopicsView: TrendingTopicsView!
    var episodesHeaderView: DiscoverCollectionViewHeaderView!
    var topEpisodesTableView: UITableView!
    var seriesHeaderView: DiscoverCollectionViewHeaderView!
    var topSeriesCollectionView: UICollectionView!
    var topicLabel: UILabel!

    let episodesReuseIdentifier = "episodes"
    let seriesReuseIdentifier = "series"
    let episodesHeaderTag = 1
    let seriesHeaderTag = 2
    let collectionViewHeight: CGFloat = 160
    let relatedTopicsHeight: CGFloat = 150

    var relatedTopics = [Topic]()
    var topEpisodes = [Episode]()
    var topSeries = [Series]()
    var parentTopic: Topic?

    override var pageSize: Int { get { return 10 } }

    var topic: Topic!
    var currentlyPlayingIndexPath: IndexPath?

    convenience init(topic: Topic, parentTopic: Topic? = nil) {
        self.init()
        self.topic = topic
        self.parentTopic = parentTopic
    }

    convenience init(topicType: TopicType) {
        self.init()
        self.topic = topicType.toTopic()
        self.parentTopic = topicType.getParentTopic()?.toTopic()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        topEpisodesTableView = createEpisodesTableView()
        topEpisodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodesReuseIdentifier)
        topEpisodesTableView.delegate = self
        topEpisodesTableView.dataSource = self
        topEpisodesTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        topEpisodesTableView.addInfiniteScroll { _ in
            guard let id = self.topic.id else { return }
            self.fetchEpisodes(id: id)
        }
        mainScrollView = topEpisodesTableView

        topicLabel = UILabel(frame: .zero)
        topicLabel.font = ._16SemiboldFont()
        topicLabel.textColor = .offWhite
        topicLabel.textAlignment = .center

        relatedTopicsView = TrendingTopicsView(frame: .zero, type: .related)
        relatedTopicsView.isUserInteractionEnabled = true
        relatedTopicsView.dataSource = self
        relatedTopicsView.delegate = self
        headerView.addSubview(relatedTopicsView)
        relatedTopicsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(relatedTopicsHeight)
        }

        seriesHeaderView = createCollectionHeaderView(type: .series, tag: seriesHeaderTag)
        headerView.addSubview(seriesHeaderView)
        seriesHeaderView.delegate = self
        seriesHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(relatedTopicsView.snp.bottom)
            make.height.equalTo(headerHeight)
        }

        topSeriesCollectionView = createCollectionView(type: .discover)
        headerView.addSubview(topSeriesCollectionView)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: episodesReuseIdentifier)
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionViewHeight)
            make.top.equalTo(seriesHeaderView.snp.bottom)
        }

        let episodesHeaderView = createCollectionHeaderView(type: .episodes, tag: episodesHeaderTag)
        headerView.addSubview(episodesHeaderView)
        episodesHeaderView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topSeriesCollectionView.snp.bottom)
            make.height.equalTo(headerHeight)
        }

        topEpisodesTableView.tableHeaderView = headerView
        // adjust header height
        headerView.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
        }

        loadingAnimation = LoadingAnimatorUtilities.createLoadingAnimator()
        view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { make in
            make.center.equalTo(topSeriesCollectionView.snp.center)
        }
        loadingAnimation.startAnimating()

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        setup()
    }

    override func stylizeNavBar() {
        navigationController?.navigationBar.tintColor = .offWhite
        navigationItem.titleView = topicLabel
        navigationController?.navigationBar.backgroundColor = .clear // to not show navigation bar
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var image = UIImage()
        if let parent = parentTopic, let parentTopicType = parent.topicType, parent != topic {
            // display "Parent Topic | Subtopic"
            image = parentTopicType.headerImage
            let topicString = NSMutableAttributedString()
            let regularAttributes = [
                NSAttributedStringKey.font: UIFont._16RegularFont(),
                NSAttributedStringKey.foregroundColor: UIColor.offWhite
            ]
            let boldAttributes = [
                NSAttributedStringKey.font: UIFont._16SemiboldFont(),
                NSAttributedStringKey.foregroundColor: UIColor.offWhite
            ]
            let regularString = NSMutableAttributedString(string: parent.name, attributes: regularAttributes)
            let boldString = NSMutableAttributedString(string: " | \(topic.name)", attributes: boldAttributes)
            topicString.append(regularString)
            topicString.append(boldString)
            topicLabel.attributedText = topicString
        } else if let topicType = topic.topicType {
            // parent topic
            image = topicType.headerImage
            topicLabel.text = topic.name
        }
        UIApplication.shared.statusBarStyle = .lightContent
        topicLabel.sizeToFit()
        stylizeNavBar()
        navigationController?.navigationBar.setBackgroundImage(image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        topSeriesCollectionView.reloadData()
        topEpisodesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DownloadManager.shared.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        super.stylizeNavBar()
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        super.stylizeNavBar()
    }

    func setup(canPullToRefresh: Bool = false) {
        guard let id = topic.id else { return }

        fetchEpisodes(id: id, canPullToRefresh: canPullToRefresh)

        let topSeriesForTopicEndpointRequest = DiscoverTopicEndpointRequest(requestType: .series, topicID: id)
        topSeriesForTopicEndpointRequest.success = { response in
            guard let series = response.processedResponseValue as? [Series] else { return }
            self.topSeries = series
            self.topSeriesCollectionView.reloadData()
        }

        System.endpointRequestQueue.addOperation(topSeriesForTopicEndpointRequest)
        setupTopicHeader()
    }

    func setupTopicHeader() {
        // set up "Related Topics": display either subtopics or other subtopics of parent topic,
        // otherwise, remove and don't display related topics
        if let parent = parentTopic, let subtopics = parent.subtopics, parent != topic {
            relatedTopics = subtopics.filter({ topic -> Bool in
                self.topic != topic
            })
            relatedTopics.append(parent)
        } else if let mySubtopics = topic.subtopics, mySubtopics.count > 0 {
            relatedTopics = mySubtopics
        } else {
            relatedTopicsView.snp.updateConstraints({ make in
                make.height.equalTo(0)
            })
            relatedTopicsView.isHidden = true

            // adjust the tableView header height
            let headerViewHeight = collectionViewHeight + 2 * headerHeight
            headerView.snp.remakeConstraints { make in
                make.height.equalTo(headerViewHeight)
                make.width.top.centerX.equalToSuperview()
            }

            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
        relatedTopicsView.collectionView.reloadData()
    }

    func fetchEpisodes(id: Int, canPullToRefresh: Bool = false) {

        if canPullToRefresh {
            offset = 0
        }

        let topEpisodesForTopicEndpointRequest = DiscoverTopicEndpointRequest(requestType: .episodes, topicID: id, offset: offset, max: pageSize)
        topEpisodesForTopicEndpointRequest.success = { response in
            guard let episodes = response.processedResponseValue as? [Episode] else { return }
            if episodes.count == 0 {
                self.continueInfiniteScroll = false
            }
            self.topEpisodes = canPullToRefresh ? episodes : self.topEpisodes + episodes
            self.offset += self.pageSize
            self.topEpisodesTableView.reloadData()
            self.topEpisodesTableView.finishInfiniteScroll()
            self.loadingAnimation.stopAnimating()
            self.topEpisodesTableView.refreshControl?.endRefreshing()
        }

        topEpisodesForTopicEndpointRequest.failure = { _ in
            self.topEpisodesTableView.finishInfiniteScroll()
        }

        System.endpointRequestQueue.addOperation(topEpisodesForTopicEndpointRequest)
    }

    override func handlePullToRefresh() {
        if let refreshControl = topEpisodesTableView.refreshControl {
            refreshControl.beginRefreshing()
            setup(canPullToRefresh: true)
        }
    }

}

// MARK: TopicsCollectionView Data Source

extension DiscoverTopicViewController: TopicsCollectionViewDataSource {

    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return relatedTopics[index]
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return relatedTopics.count
    }

}

// MARK: TrendingTopicsView Delegate

extension DiscoverTopicViewController: TrendingTopicsViewDelegate {
    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        let discoverTopicViewController = DiscoverTopicViewController(topic: relatedTopics[indexPath.row], parentTopic: parentTopic == nil ? topic : parentTopic)
        navigationController?.pushViewController(discoverTopicViewController, animated: true)
    }
}

// MARK: CollectionView Data Source

extension DiscoverTopicViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topSeriesCollectionView:
            return topSeries.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: episodesReuseIdentifier, for: indexPath) as? SeriesGridCollectionViewCell else { return UICollectionViewCell() }
        switch collectionView {
        case topSeriesCollectionView:
            cell.configureForSeries(series: topSeries[indexPath.row])
        default:
            break
        }
        return cell
    }

}

// MARK: CollectionView Delegate

extension DiscoverTopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case topSeriesCollectionView:
            let seriesDetailViewController = SeriesDetailViewController()
            seriesDetailViewController.series = topSeries[indexPath.row]
            navigationController?.pushViewController(seriesDetailViewController, animated: true)
        default:
            break
        }
    }
}

// MARK: Discover Header View

extension DiscoverTopicViewController: DiscoverTableViewHeaderDelegate {
    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeaderView) {
        switch sender.tag {
        case seriesHeaderTag:
            guard let id = topic.id else { break }
            let browseSeriesViewController = BrowseSeriesViewController(mediaType: .topic(id: id), series: topSeries)
            navigationController?.pushViewController(browseSeriesViewController, animated: true)
        default:
            break
        }
    }

}

// MARK: TableView Data Source

extension DiscoverTopicViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: episodesReuseIdentifier, for: indexPath) as? EpisodeTableViewCell else { return EpisodeTableViewCell() }
        cell.delegate = self
        let episode = topEpisodes[indexPath.row]
        cell.setup(with: episode, downloadStatus: DownloadManager.shared.status(for: episode.id))
        if topEpisodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
        }
        return cell
    }

}

// MARK: TableView Delegate

extension DiscoverTopicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeDetailViewController = EpisodeDetailViewController()
        episodeDetailViewController.episode = topEpisodes[indexPath.row]
        navigationController?.pushViewController(episodeDetailViewController, animated: true)
    }
}

// MARK: EpisodeTableViewCell Delegate

extension DiscoverTopicViewController: EpisodeTableViewCellDelegate {

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

extension DiscoverTopicViewController: EpisodeDownloader {
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
