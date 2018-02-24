//
//  DiscoverTopicViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

/// Displays the discoverable content for a given topic. 
class DiscoverTopicViewController: DiscoverComponentViewController {

    var topicImageView: UIImageView!
    var topicLabel: UILabel!
    var relatedTopicsView: TrendingTopicsView!
    var episodesHeaderView: DiscoverCollectionViewHeaderView!
    var topEpisodesTableView: UITableView!
    var seriesHeaderView: DiscoverCollectionViewHeaderView!
    var topSeriesCollectionView: UICollectionView!

    let episodesReuseIdentifier = "episodes"
    let seriesReuseIdentifier = "series"
    let headerReuseIdentifier = "header"
    let episodesHeaderTag = 1
    let seriesHeaderTag = 2
    let collectionViewHeight: CGFloat = 160
    let imageViewHeight: CGFloat = 72
    let relatedTopicsHeight: CGFloat = 150

    var relatedTopics = [Topic]()
    var topEpisodes = [Episode]()
    var topSeries = [Series]()
    var parentTopic: Topic?

    var topic: Topic!
    var currentlyPlayingIndexPath: IndexPath?

    convenience init(topic: Topic, parentTopic: Topic? = nil) {
        self.init()
        self.topic = topic
        self.parentTopic = parentTopic
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        topicImageView = UIImageView(frame: .zero)
        contentView.addSubview(topicImageView)
        topicImageView.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }

        topicLabel = UILabel(frame: .zero)
        topicLabel.font = ._16SemiboldFont()
        topicLabel.textColor = .offWhite
        topicLabel.textAlignment = .center
        contentView.addSubview(topicLabel)
        topicLabel.snp.makeConstraints { make in
            make.center.equalTo(topicImageView.snp.center)
        }

        relatedTopicsView = TrendingTopicsView(frame: .zero, type: .related)
        relatedTopicsView.isUserInteractionEnabled = true
        relatedTopicsView.dataSource = self
        relatedTopicsView.delegate = self
        contentView.addSubview(relatedTopicsView)
        relatedTopicsView.snp.makeConstraints { make in
            make.top.equalTo(topicImageView.snp.bottom)
            make.width.leading.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(relatedTopicsHeight)
        }

        seriesHeaderView = createCollectionHeaderView(type: .series, tag: seriesHeaderTag)
        seriesHeaderView.delegate = self
        seriesHeaderView.snp.makeConstraints { make in
            make.leading.trailing.width.equalToSuperview()
            make.top.equalTo(relatedTopicsView.snp.bottom)
            make.height.equalTo(headerHeight)
        }

        topSeriesCollectionView = createCollectionView(type: .discover)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: episodesReuseIdentifier)
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionViewHeight)
            make.top.equalTo(seriesHeaderView.snp.bottom)
        }

        topEpisodesTableView = createEpisodesTableView()
        topEpisodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodesReuseIdentifier)
        topEpisodesTableView.delegate = self
        topEpisodesTableView.dataSource = self
        topEpisodesTableView.addInfiniteScroll { _ in
            guard let id = self.topic.id else { return }
            self.fetchEpisodes(id: id)
        }

        configureTopic()
    }

    func configureTopic() {
        // dummy data
        let s = Series()
        s.title = "Design Details"
        topSeries = [s, s, s, s, s]
        let e = Episode()
        e.seriesTitle = s.title
        e.title = "Episode"
        topEpisodes = [e, e, e, e, e]
        topEpisodesTableView.reloadData()

        guard let id = topic.id else { return }
        fetchEpisodes(id: id)

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
        // set topic image header
        if let parent = parentTopic, let parentTopicType = TopicType(rawValue: parent.name), parent != topic {
            // display "Parent Topic | Subtopic"
            topicImageView.image = parentTopicType.headerImage
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
        } else if let topicType = TopicType(rawValue: topic.name) {
            // parent topic
            topicImageView.image = topicType.headerImage
            topicLabel.text = topic.name
        }

        // set up "Related Topics"
        if let parent = parentTopic, let subtopics = parent.subtopics, parent != topic {
            relatedTopics = subtopics.filter({ topic -> Bool in
                self.topic != topic
            })
            relatedTopics.append(parent)
        } else if let mySubtopics = topic.subtopics, mySubtopics.count > 0 {
            relatedTopics = mySubtopics
        } else {
            seriesHeaderView.snp.makeConstraints { make in
                make.leading.trailing.width.equalToSuperview()
                make.top.equalTo(topicImageView.snp.bottom)
                make.height.equalTo(headerHeight)
            }
            relatedTopicsView.isHidden = true
        }
    }

    func fetchEpisodes(id: Int) {

        // todo: delete this
        self.topEpisodesTableView.snp.makeConstraints { make in
            make.width.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topSeriesCollectionView.snp.bottom)
            make.height.equalTo(self.topEpisodesTableView.contentSize.height)
        }

        let topEpisodesForTopicEndpointRequest = DiscoverTopicEndpointRequest(requestType: .episodes, topicID: id)
        topEpisodesForTopicEndpointRequest.success = { response in
            guard let episodes = response.processedResponseValue as? [Episode] else { return }
            if episodes.count == 0 {
                self.continueInfiniteScroll = false
            }
            self.topEpisodes = self.topEpisodes + episodes
            self.offset += self.pageSize
            self.topEpisodesTableView.reloadData()
            self.topEpisodesTableView.finishInfiniteScroll()
            self.topEpisodesTableView.reloadData()
            self.topEpisodesTableView.snp.makeConstraints { make in
                make.width.bottom.equalToSuperview()
                make.top.equalTo(self.topSeriesCollectionView.snp.bottom)
                make.height.equalTo(self.topEpisodesTableView.contentSize.height)
            }
        }

        topEpisodesForTopicEndpointRequest.failure = { _ in
            self.topEpisodesTableView.finishInfiniteScroll()
        }

        System.endpointRequestQueue.addOperation(topEpisodesForTopicEndpointRequest)
    }
}

// MARK: - RelatedTopicsHeader
extension DiscoverTopicViewController: TopicsCollectionViewDataSource, TrendingTopicsViewDelegate {
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return relatedTopics[index]
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return relatedTopics.count
    }

    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        let discoverTopicViewController = DiscoverTopicViewController(topic: relatedTopics[indexPath.row], parentTopic: parentTopic == nil ? topic : parentTopic)
        navigationController?.pushViewController(discoverTopicViewController, animated: true)
    }
}

// MARK: - Collection View
extension DiscoverTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - Discover Header View
extension DiscoverTopicViewController: DiscoverTableViewHeaderDelegate {
    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeaderView) {
        switch sender.tag {
        case seriesHeaderTag:
            let vc = BrowseSeriesViewController()
            vc.series = topSeries
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}

extension DiscoverTopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: episodesReuseIdentifier, for: indexPath) as? EpisodeTableViewCell else { return EpisodeTableViewCell() }
        cell.delegate = self
        cell.setupWithEpisode(episode: topEpisodes[indexPath.row])
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

extension DiscoverTopicViewController: EpisodeTableViewCellDelegate {
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
