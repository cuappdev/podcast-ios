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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let series = series else { return }
        updateSeriesHeader(series: series)
        episodeTableView.reloadData()
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
        seriesHeaderView.isHidden = false
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
    
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int) {
        guard let series = series else { return }
        if 0..<series.tags.count ~= index {
//            let tag = series.tags[index]
//            let tagViewController = TagViewController()
//            tagViewController.tag = tag
            navigationController?.pushViewController(UnimplementedViewController(), animated: true)
        }
    }
    
    //create and delete subscriptions
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView) {
        series!.subscriptionChange(completion: seriesDetailHeader.subscribeButtonChangeState)
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
        return episodes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCellIdentifier") as! EpisodeTableViewCell
        cell.delegate = self
        cell.setupWithEpisode(episode: episodes[indexPath.row])
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
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = episodes[episodeIndexPath.row]
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        episodeTableViewCell.updateWithPlayButtonPress(episode: episode)

        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = episodeTableView.cellForRow(at: playingIndexPath) as? EpisodeTableViewCell {
            let playingEpisode = episodes[playingIndexPath.row]
            currentlyPlayingCell.updateWithPlayButtonPress(episode: playingEpisode)
        }

        // update index path
        currentlyPlayingIndexPath = episodeIndexPath
    }

    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = episodes[episodeIndexPath.row]
        episode.recommendedChange(completion: episodeTableViewCell.setRecommendedButtonToState)
    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = episodes[episodeIndexPath.row]
        episode.bookmarkChange(completion: episodeTableViewCell.setBookmarkButtonToState)
    }
    
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
//        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell) else { return }
//        let episode = episodes[episodeIndexPath.row]
//        let tagViewController = TagViewController()
//        tagViewController.tag = episode.tags[index]
        navigationController?.pushViewController(UnimplementedViewController(), animated: true)
    }
    
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = episodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = episodes[episodeIndexPath.row]
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        
        var header: ActionSheetHeader?
        
        if let image = episodeTableViewCell.episodeSubjectView.podcastImage?.image, let title = episodeTableViewCell.episodeSubjectView.episodeNameLabel.text, let description = episodeTableViewCell.episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
}
