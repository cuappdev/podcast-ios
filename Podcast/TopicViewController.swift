//
//  TopicViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class TopicViewController: ViewController, UITableViewDelegate, UITableViewDataSource,RecommendedSeriesTableViewCellDelegate, RecommendedSeriesTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource, TopicTableViewHeaderDelegate {

    var tableView: UITableView!
    var topic: Topic!
    var episodes: [Episode] = []
    var series: [Series] = []
    
    var sectionNames = ["Top Series in ", "Top Episodes in "]
    let sectionHeaderHeight: CGFloat = 45
    let sectionContentClasses: [AnyClass] = [RecommendedSeriesTableViewCell.self, RecommendedEpisodesOuterTableViewCell.self]
    let sectionContentIndentifiers = ["SeriesCell", "EpisodesCell"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .paleGrey
        
        setupNavigationBar()
        
        for i in 0..<sectionNames.count {
            sectionNames[i] = sectionNames[i] + topic.name
        }
        
        // Instantiate tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        for (contentClass, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            tableView.register(contentClass.self, forCellReuseIdentifier: identifier)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .paleGrey
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        mainScrollView = tableView
        view.addSubview(tableView)
        
        fetchSeries()
        fetchEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNavigationBar() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: (navigationController?.navigationBar.frame.height)!))
        let titleView = UILabel(frame: CGRect.zero)
        titleView.text = topic.name
        titleView.sizeToFit()
        titleView.center = CGPoint(x: headerView.frame.width / 2, y: headerView.frame.height / 2)
        headerView.addSubview(titleView)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "tag_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.frame.origin.x = titleView.frame.origin.x - imageView.frame.width - 10
        imageView.center.y = titleView.center.y
        headerView.addSubview(imageView)
        headerView.sizeToFit()
        navigationItem.titleView = headerView
    }
    
    //MARK
    //MARK: - TableView DataSource & Delegate
    //MARK
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // don't know how to condense this using an array like the other functions
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) else { return UITableViewCell() }
        if let cell = cell as? RecommendedSeriesTableViewCell {
            cell.dataSource = self
            cell.delegate = self
            cell.backgroundColor = .paleGrey
        } else if let cell = cell as? RecommendedEpisodesOuterTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TopicTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeight))
        header.delegate = self
        switch section {
        case 0:
            header.type = .seriesHeader
        case 1:
            header.type = .episodesHeader
        default:
            header.type = .seriesHeader
        }
        header.configure(sectionName: sectionNames[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            return CGFloat(episodes.count) * EpisodeSubjectView.episodeSubjectViewHeight
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    //MARK: - RecommendedSeriesTableViewCell DataSource & Delegate
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, dataForItemAt indexPath: IndexPath) -> Series {
        return series[indexPath.row]
    }
    
    func numberOfRecommendedSeries(forRecommendedSeriesTableViewCell cell: RecommendedSeriesTableViewCell) -> Int {
        return series.count
    }
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, didSelectItemAt indexPath: IndexPath) {
        
        let seriesDetailViewController = SeriesDetailViewController(series: series[indexPath.row])
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
        
    }
    
    //MARK: - RecommendedEpisodesOuterTableViewCell DataSource & Delegate
    
    func recommendedEpisodesTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, dataForItemAt indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
    
    func numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell cell: RecommendedEpisodesOuterTableViewCell) -> Int {
        return episodes.count
    }
    
    func recommendedEpisodesOuterTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, didSelectItemAt indexPath: IndexPath) {
        print("Selected episode at \(indexPath.row)")
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressPlayButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        episode.bookmarkChange(completion: episodeTableViewCell.setBookmarkButtonToState)
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        episode.recommendedChange(completion: episodeTableViewCell.setRecommendedButtonToState)
    }
    
    func recommendedEpisodesOuterTableViewCellDidPressShowActionSheet(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        var header: ActionSheetHeader?
        
        if let image = episodeTableViewCell.episodeSubjectView.podcastImage.image, let title = episodeTableViewCell.episodeSubjectView.episodeNameLabel.text, let description = episodeTableViewCell.episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func recommendedEpisodesOuterTableViewCellDidPressTopicButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode, index: Int) {
        let topicViewController = TopicViewController()
        topicViewController.topic = episode.topics[index]
        navigationController?.pushViewController(topicViewController, animated: true)
    }
    
    //MARK - TopicTableViewHeaderDelegate
    
    func topicTableViewHeaderDidPressViewAllButton(view: TopicTableViewHeader) {
        print("Pressed view all")
    }
    
    //MARK: - Endpoints 
    
    func fetchSeries() {
        let s = Series()
        s.title = "Design Details"
        series = Array(repeating: s, count: 7)
    }
    
    func fetchEpisodes() {
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.topics = [Topic(name:"Design"), Topic(name:"Learning"), Topic(name: "User Experience"), Topic(name:"Technology"), Topic(name:"Innovation"), Topic(name:"Dogs")]
        episodes = Array(repeating: episode, count: 5)
        
    }
}
