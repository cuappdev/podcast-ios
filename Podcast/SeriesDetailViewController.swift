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
    
    var series: Series!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSeries()
        createSubviews()
        updateViewsWithSeries(series: series)        
    }
    
    func createSubviews() {
        let seriesHeaderViewframe = CGRect(x: 0, y:0, width: view.frame.width, height: seriesHeaderHeight)
        seriesHeaderView = SeriesDetailHeaderView(frame: seriesHeaderViewframe)
        seriesHeaderView.delegate = self
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let tableViewframe = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight)
        epsiodeTableView = UITableView(frame: tableViewframe, style: .plain)
        epsiodeTableView.delegate = self
        epsiodeTableView.dataSource = self
        epsiodeTableView.tableHeaderView = seriesHeaderView
        epsiodeTableView.showsVerticalScrollIndicator = false
        epsiodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCellIdentifier")
        
        view.addSubview(epsiodeTableView)
    }
    
    func fetchSeries() {
        // For now dummy data, later endpoint request

        // Setup dummy data
        let s = Series()
        s.title = "Dog Pods"
        s.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        s.author = "Dog Lovers"
        s.tags = [Tag(name: "Design")]
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.series = s
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.tags = [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")]
        s.episodes = [episode]
        series = s
    }
    
    func updateViewsWithSeries(series: Series) {
        self.series = series
        seriesHeaderView.setSeries(series: series)
        navigationItem.title = series.title
        epsiodeTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int) {
        // Index is index of tag in array
    }
    
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView, subscribed: Bool) {
        // Toggle subscribe (aka endpoint request)
        
        // When request comes back, update in case it failed
//        seriesHeaderView.subscribeButtonChangeState(isSelected: subscribed)
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
        return series.episodes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCellIdentifier") as! EpisodeTableViewCell
        cell.delegate = self
        cell.setupWithEpisode(episode: series.episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EpisodeTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
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
        
        tableView.sendSubview(toBack: view)
    }
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series.episodes[episodeIndexPath.row]
        
        //episode.isPlaying = !episode.isPlaying
        //episodeTableViewCell.setPlayButtonState(isPlaying: episode.isPlaying)
    }
    
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series.episodes[episodeIndexPath.row]
        
        episode.isRecommended = !episode.isRecommended
        episodeTableViewCell.setRecommendedButtonState(isRecommended: episode.isRecommended)
    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = epsiodeTableView.indexPath(for: episodeTableViewCell) else { return }
        let episode = series.episodes[episodeIndexPath.row]
        
        episode.isBookmarked = !episode.isBookmarked
        episodeTableViewCell.setBookmarkButtonState(isBookmarked: episode.isBookmarked)
    }
    
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
        
    }

}
