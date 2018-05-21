//
//  SeriesDetailViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SeriesDetailViewController: ViewController, SeriesDetailHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource, TopicsCollectionViewDataSource, EpisodeTableViewCellDelegate, NVActivityIndicatorViewable  {

    override var usesLargeTitles: Bool { get { return false } }
    let seriesHeaderViewMinHeight: CGFloat = SeriesDetailHeaderView.minHeight
    let sectionHeaderHeight: CGFloat = 12.5
    let sectionTitleY: CGFloat = 32.0
    let sectionTitleHeight: CGFloat = 18.0
    let padding: CGFloat = 18.0
    let separatorHeight: CGFloat = 1.0
    
    var seriesHeaderView: SeriesDetailHeaderView!
    var episodeTableView: UITableView!
    var loadingAnimation: NVActivityIndicatorView!
    
    var series: Series?
    let pageSize = 20
    var offset = 0
    var continueInfiniteScroll = true
    var currentlyPlayingIndexPath: IndexPath?
    
    var episodes: [Episode] = []
    
    convenience init(series: Series) {
        self.init()
        self.series = series
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seriesHeaderView = SeriesDetailHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: seriesHeaderViewMinHeight))
        seriesHeaderView.delegate = self
        seriesHeaderView.dataSource = self
        seriesHeaderView.isHidden = true

        episodeTableView = UITableView()
        episodeTableView.rowHeight = UITableViewAutomaticDimension
        episodeTableView.delegate = self
        episodeTableView.backgroundColor = .paleGrey
        episodeTableView.dataSource = self
        episodeTableView.tableHeaderView = seriesHeaderView
        episodeTableView.showsVerticalScrollIndicator = false
        episodeTableView.separatorStyle = .none
        episodeTableView.addInfiniteScroll { (tableView) -> Void in
            if let seriesID = self.series?.seriesId {
                self.fetchEpisodes(seriesID: seriesID)
            }
        }
        //tells the infinite scroll when to stop
        episodeTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        episodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCellIdentifier")
        mainScrollView = episodeTableView

        episodeTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()

        view.addSubview(episodeTableView)

        episodeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingAnimation = LoadingAnimatorUtilities.createLoadingAnimator()
        view.addSubview(loadingAnimation)
        
        loadingAnimation.snp.makeConstraints { make in
            make.center.equalTo(seriesHeaderView)
        }
        
        loadingAnimation.startAnimating()
        
        if let series = series {
            setSeries(series: series)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let series = series else { return }
        updateSeriesHeader(series: series)
        episodeTableView.reloadData()
        viewDidLayoutSubviews()
        DownloadManager.shared.delegate = self
    }
    
    // use if creating this view from just a seriesID
    func fetchSeries(seriesID: String) {
        let seriesBySeriesIdEndpointRequest = FetchSeriesForSeriesIDEndpointRequest(seriesID: seriesID)

        seriesBySeriesIdEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let series = endpointRequest.processedResponseValue as? Series else { return }
            self.updateSeriesHeader(series: series)
            self.loadingAnimation.stopAnimating()
        }
        
        System.endpointRequestQueue.addOperation(seriesBySeriesIdEndpointRequest)
        fetchEpisodes(seriesID: seriesID)
    }
    
    func updateSeriesHeader(series: Series) {
        self.series = series
        seriesHeaderView.setSeries(series: series)
        resizeSeriesHeaderView()
        seriesHeaderView.isHidden = false
    }
    
    func resizeSeriesHeaderView() {
        if let headerView = episodeTableView.tableHeaderView as? SeriesDetailHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            if height != headerFrame.size.height {
                headerFrame.size.height = max(height, seriesHeaderViewMinHeight)
                headerView.frame = headerFrame
                episodeTableView.tableHeaderView = headerView
            }
        }
    }
    
    private func setSeries(series: Series) {
        self.loadingAnimation.stopAnimating()
        updateSeriesHeader(series: series)
        fetchEpisodes(seriesID: series.seriesId)
    }
    
    func fetchEpisodes(seriesID: String) {
        let episodesBySeriesIdEndpointRequest = FetchEpisodesForSeriesIDEndpointRequest(seriesID: seriesID, offset: offset, max: pageSize)
        episodesBySeriesIdEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let episodes = endpointRequest.processedResponseValue as? [Episode] else { return }
            if episodes.count == 0 {
                self.continueInfiniteScroll = false
            }
            self.episodes = self.episodes + episodes
            self.offset += self.pageSize
            self.episodeTableView.finishInfiniteScroll()
            self.episodeTableView.reloadData()
        }

        episodesBySeriesIdEndpointRequest.failure = { _ in
            self.episodeTableView.finishInfiniteScroll()
        }
        
        System.endpointRequestQueue.addOperation(episodesBySeriesIdEndpointRequest)
    }
    
    func seriesDetailHeaderViewDidPressTopicButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int) {
        guard let series = series else { return }
        if 0..<series.topics.count ~= index {
            guard let topicType = series.topics[index].topicType else { return }
            let topicViewController = DiscoverTopicViewController(topicType: topicType)
            navigationController?.pushViewController(topicViewController, animated: true)
        }
    }
    
    //create and delete subscriptions
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView) {
        series!.subscriptionChange(completion: seriesDetailHeader.subscribeButtonChangeState)
    }
    
    func seriesDetailHeaderViewDidPressMoreTopicsButton(seriesDetailHeader: SeriesDetailHeaderView) {
        // Show view of all tags?
    }
    
    func seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: SeriesDetailHeaderView) {
        
    }
    
    func seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: SeriesDetailHeaderView) {
        let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCellIdentifier") as! EpisodeTableViewCell
        cell.delegate = self
        let episode = episodes[indexPath.row]
        let status = DownloadManager.shared.status(for: episode.id)
        cell.setup(with: episode, downloadStatus: status)
        cell.layoutSubviews()
        if episodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episodes[indexPath.row]
        navigationController?.pushViewController(episodeViewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scale: CGFloat = 50.0
        let offset = max(0, -(scrollView.contentOffset.y + scrollView.adjustedContentInset.top))
        let scaledOffset = offset / scale

        seriesHeaderView.infoView.alpha = 1.0 - scaledOffset
        seriesHeaderView.contentContainerTop?.update(offset: -offset)
        seriesHeaderView.gradientView.alpha = 1.85 - scaledOffset * 0.75
    }
    
    // MARK: - TopicsCollectionViewCellDataSource
    
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        guard let series = series else { return Topic(name: "")}
        let topic = 0..<series.topics.count ~= index ? series.topics[index] : Topic(name: "")
        return topic
    }
    
    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return series?.topics.count ?? 0
    }

    func didPress(on action: EpisodeAction, for cell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: cell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = episodes[episodeIndexPath.row]

        switch action {
        case .play:
            appDelegate.showAndExpandPlayer()
            Player.sharedInstance.playEpisode(episode: episode)
            cell.updateWithPlayButtonPress(episode: episode)

            // reset previously playings view
            if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = episodeTableView.cellForRow(at: playingIndexPath) as? EpisodeTableViewCell {
                let playingEpisode = episodes[playingIndexPath.row]
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
            editRecastAction(episode: episode, completion:
                { _,_ in
                    cell.setup(with: episode, downloadStatus: DownloadManager.shared.status(for: episode.id))
            })
        }
    }
}

extension SeriesDetailViewController: EpisodeDownloader {
    func didReceive(statusUpdate: DownloadStatus, for episode: Episode) {
        if let row = episodes.index(of: episode) {
            episodeTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
}
