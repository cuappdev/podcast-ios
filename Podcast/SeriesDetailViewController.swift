//
//  SeriesDetailViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SeriesDetailViewController: ViewController, SeriesDetailHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource, TagsCollectionViewDataSource, EpisodeTableViewCellDelegate, NVActivityIndicatorViewable  {
    
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
        setSeries(series: series)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seriesHeaderView = SeriesDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: seriesHeaderViewMinHeight))
        seriesHeaderView.delegate = self
        seriesHeaderView.isHidden = true

        episodeTableView = UITableView()
        view.addSubview(episodeTableView)
        
        episodeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        episodeTableView.rowHeight = UITableViewAutomaticDimension
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        episodeTableView.tableHeaderView = seriesHeaderView
        episodeTableView.showsVerticalScrollIndicator = false
        episodeTableView.separatorStyle = .none
        episodeTableView.addInfiniteScroll { (tableView) -> Void in
            self.fetchEpisodes()
        }
        //tells the infinite scroll when to stop
        episodeTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        episodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCellIdentifier")
        mainScrollView = episodeTableView

        episodeTableView.infiniteScrollIndicatorView = createLoadingAnimationView()
        
        automaticallyAdjustsScrollViewInsets = false
        
        loadingAnimation = createLoadingAnimationView()
        view.addSubview(loadingAnimation)
        
        loadingAnimation.snp.makeConstraints { make in
            make.center.equalTo(seriesHeaderView)
        }
        
        loadingAnimation.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let series = self.series else { return }
        
        self.loadingAnimation.stopAnimating()
        self.seriesHeaderView.isHidden = false
        
        // check before reloading data whether the Player has stopped playing the currentlyPlayingIndexPath
        if let indexPath = currentlyPlayingIndexPath {
            let episode = series.episodes[indexPath.row]
            if Player.sharedInstance.currentEpisode?.id != episode.id {
                currentlyPlayingIndexPath = nil
            }
        }
    }
    
    // use if creating this view from just a seriesID
    func fetchAndSetSeries(seriesID: String) {
        let seriesBySeriesIdEndpointRequest = FetchSeriesForSeriesIDEndpointRequest(seriesID: seriesID)

        seriesBySeriesIdEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let series = endpointRequest.processedResponseValue as? Series else { return }
            self.setSeries(series: series)
        }
        
        System.endpointRequestQueue.addOperation(seriesBySeriesIdEndpointRequest)
    }
    
    func setSeries(series: Series) {
        self.series = series
        title = series.title
        fetchEpisodes()
        
        DispatchTime.waitFor(milliseconds: 100) {
            self.loadingAnimation.stopAnimating()
            self.seriesHeaderView.setSeries(series: series)
            self.seriesHeaderView.dataSource = self
            self.seriesHeaderView.isHidden = false
            self.seriesHeaderView.sizeToFit()
        }
    }
    
    func fetchEpisodes() {
        let episodesBySeriesIdEndpointRequest = FetchEpisodesForSeriesIDEndpointRequest(seriesID: String(series!.seriesId), offset: offset, max: pageSize)
        episodesBySeriesIdEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let episodes = endpointRequest.processedResponseValue as? [Episode] else { return }
            if episodes.count == 0 {
                self.episodeTableView.finishInfiniteScroll()
                self.continueInfiniteScroll = false
            }
            self.series!.episodes = self.series!.episodes + episodes
            self.offset += self.pageSize
            self.episodeTableView.finishInfiniteScroll()
            self.episodeTableView.reloadData()
        }
        System.endpointRequestQueue.addOperation(episodesBySeriesIdEndpointRequest)
    }
    
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int) {
        let tagViewController = TagViewController()
        guard let series = series else { return }
        if 0..<series.tags.count ~= index {
            let tag = series.tags[index]
            tagViewController.tag = tag
            navigationController?.pushViewController(tagViewController, animated: true)
        }
    }
    
    //create and delete subscriptions
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView) {
        if !series!.isSubscribed {
            let createSubscriptionEndpointRequest = CreateUserSubscriptionEndpointRequest(seriesID: String(series!.seriesId))
            createSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                self.series!.isSubscribed = true
                seriesDetailHeader.subscribeButtonChangeState(isSelected: self.series!.isSubscribed)
            }
            createSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                self.series!.isSubscribed = false
                seriesDetailHeader.subscribeButtonChangeState(isSelected: self.series!.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(createSubscriptionEndpointRequest)
        } else {
            let deleteSubscriptionEndpointRequest = DeleteUserSubscriptionEndpointRequest(seriesID: String(series!.seriesId))
            deleteSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                self.series!.isSubscribed = false
                seriesDetailHeader.subscribeButtonChangeState(isSelected: self.series!.isSubscribed)
            }
            deleteSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                self.series!.isSubscribed = true
                seriesDetailHeader.subscribeButtonChangeState(isSelected: self.series!.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(deleteSubscriptionEndpointRequest)
        }
    }
    
    func seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: SeriesDetailHeaderView) {
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
        if let series = self.series {
            return series.episodes.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCellIdentifier") as! EpisodeTableViewCell
        cell.delegate = self
        if let series = self.series {
            cell.setupWithEpisode(episode: (series.episodes[indexPath.row]))
        }
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: sectionHeaderHeight))
        headerView.backgroundColor = .paleGrey
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let episode = series?.episodes[indexPath.row] {
            let episodeViewController = EpisodeDetailViewController()
            episodeViewController.episode = episode
            navigationController?.pushViewController(episodeViewController, animated: true)
        }
    }
    
    // MARK: - TagsCollectionViewCellDataSource
    
    func tagForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Tag {
        guard let series = series else { return Tag(name: "")}
        let tag = 0..<series.tags.count ~= index ? series.tags[index] : Tag(name: "")
        return tag
    }
    
    func numberOfTags(collectionView: UICollectionView) -> Int {
        return series?.tags.count ?? 0
    }

    // MARK: - EpisodeTableViewCellDelegate
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell), episodeIndexPath != currentlyPlayingIndexPath, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let episode = series!.episodes[episodeIndexPath.row]
        if let indexPath = currentlyPlayingIndexPath, let cell = episodeTableView.cellForRow(at: indexPath) as? EpisodeTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = episodeIndexPath
        episodeTableViewCell.episodeSubjectView.episodeUtilityButtonBarView.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        let historyRequest = CreateListeningHistoryElementEndpointRequest(episodeID: episode.id)
        System.endpointRequestQueue.addOperation(historyRequest)
    }

    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series!.episodes[episodeIndexPath.row]
        
        if !episode.isRecommended {
            let endpointRequest = CreateRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = true
                episodeTableViewCell.setRecommendedButtonToState(isRecommended: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = false
                episodeTableViewCell.setRecommendedButtonToState(isRecommended: false)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series!.episodes[episodeIndexPath.row]
        
        if !episode.isBookmarked {
            let endpointRequest = CreateBookmarkEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isBookmarked = true
                episodeTableViewCell.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteBookmarkEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isBookmarked = true
                episodeTableViewCell.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell), let episode = series?.episodes[episodeIndexPath.row] else { return }
        let tagViewController = TagViewController()
        tagViewController.tag = episode.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }
    
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {
        let option1 = ActionSheetOption(title: "Mark as Played", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Remove Download", titleColor: .rosyPink, image: #imageLiteral(resourceName: "heart_icon"), action: nil)
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        var header: ActionSheetHeader?
        
        if let image = episodeTableViewCell.episodeSubjectView.podcastImage?.image, let title = episodeTableViewCell.episodeSubjectView.episodeNameLabel.text, let description = episodeTableViewCell.episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
}
