//
//  SeriesDetailViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SeriesDetailViewController: UIViewController, SeriesDetailHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource, EpisodeTableViewCellDelegate {
    
    let seriesHeaderHeight: CGFloat = SeriesDetailHeaderView.height
    
    let sectionHeaderHeight: CGFloat = 64.0
    let sectionTitleY: CGFloat = 32.0
    let sectionTitleHeight: CGFloat = 18.0
    let padding: CGFloat = 18.0
    let separatorHeight: CGFloat = 1.0
    
    var seriesHeaderView: SeriesDetailHeaderView!
    var epsiodeTableView: UITableView!
    
    var series: Series?
    let pageSize = 20
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
    }
    
    func createSubviews() {
        seriesHeaderView = SeriesDetailHeaderView(frame: CGRect(x: 0, y:0, width: view.frame.width, height: seriesHeaderHeight))
        seriesHeaderView.delegate = self

        epsiodeTableView = UITableView(frame: CGRect.zero)
        epsiodeTableView.delegate = self
        epsiodeTableView.dataSource = self
        epsiodeTableView.tableHeaderView = seriesHeaderView
        epsiodeTableView.showsVerticalScrollIndicator = false
        epsiodeTableView.separatorStyle = .none
        epsiodeTableView.addInfiniteScroll { (tableView) -> Void in
            self.fetchEpisodes()
            tableView.finishInfiniteScroll()
        }
        epsiodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCellIdentifier")
        view.addSubview(epsiodeTableView)
    }
    
    func updateSubviewsWithSeries() {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let tableViewframe = CGRect(x:0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight)
        epsiodeTableView.frame = tableViewframe
    }
    
    //use if creating this view from just a seriesID
    func fetchAndSetSeries(seriesID: String) {
        
        let seriesBySeriesIdEndpointRequest = SeriesBySeriesIdEndpointRequest(seriesID: seriesID)
        
        seriesBySeriesIdEndpointRequest.success = { (endpointRequst: EndpointRequest) in
            guard let series = endpointRequst.processedResponseValue as? Series else { return }
            self.setSeries(series: series)
        }
        
        System.endpointRequestQueue.addOperation(seriesBySeriesIdEndpointRequest)
    }
    
    //use if creating this view with a Series model
    func setSeries(series: Series) {
        self.series = series
        updateSubviewsWithSeries()
        seriesHeaderView.setSeries(series: series)
        navigationItem.title = series.title
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        let episodesBySeriesIdEndpointRequest = EpisodesBySeriesIdEndpointRequest(seriesID: String(series!.id), offset: offset, max: pageSize)
        episodesBySeriesIdEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let episodes = endpointRequest.processedResponseValue as? [Episode] else { return }
            self.series!.episodes = self.series!.episodes + episodes
            self.offset += self.pageSize
            self.epsiodeTableView.reloadData()
        }
        System.endpointRequestQueue.addOperation(episodesBySeriesIdEndpointRequest)
    }
    
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int) {
        // Index is index of tag in array
        let tagViewController = TagViewController()
        tagViewController.tag = series!.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }
    
    //create and delete subscriptions
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView) {
        if !(series!.isSubscribed) { //subscribing to series
            let createSubscriptionEndpointRequest = CreateUserSubscriptionEndpointRequest(seriesID: String(series!.id))
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
            let deleteSubscriptionEndpointRequest = DeleteUserSubscriptionEndpointRequest(seriesID: String(series!.id))
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
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series?.episodes.count ?? 0
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EpisodeTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: sectionHeaderHeight))
        view.backgroundColor = .podcastWhiteDark
        let sectionTitle = UILabel()
        sectionTitle.text = "All Episodes"
        sectionTitle.textColor = .podcastGrayDark
        sectionTitle.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        sectionTitle.sizeToFit()
        sectionTitle.frame = CGRect(x: padding, y: sectionTitleY, width: sectionTitle.frame.width, height: sectionTitleHeight)
        
        view.addSubview(sectionTitle)
        
        let separatorUpper = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        let separatorLower = UIView(frame: CGRect(x: 0, y: view.frame.height - separatorHeight, width: view.frame.width, height: 1))
        separatorUpper.backgroundColor = .podcastGray
        separatorLower.backgroundColor = .podcastGray
        
        view.addSubview(separatorUpper)
        view.addSubview(separatorLower)
        return view
    }
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell) else { return }
        
        //episode.isPlaying = !episode.isPlaying
        //episodeTableViewCell.setPlayButtonState(isPlaying: episode.isPlaying)
    }
    
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series!.episodes[episodeIndexPath.row]
        
        episode.isRecommended = !episode.isRecommended
        episodeTableViewCell.setRecommendedButtonToState(isRecommended: episode.isRecommended)
    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series!.episodes[episodeIndexPath.row]
        
        episode.isBookmarked = !episode.isBookmarked
        episodeTableViewCell.setBookmarkButtonToState(isBookmarked: episode.isBookmarked)
    }
    
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell), let episode = series!.episodes[episodeIndexPath.row] as? Episode else { return }
        let tagViewController = TagViewController()
        tagViewController.tag = episode.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }
    
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {
        
    }

}
