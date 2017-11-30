//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverViewController: ViewController, UITableViewDelegate, UITableViewDataSource, RecommendedSeriesTableViewCellDataSource, RecommendedSeriesTableViewCellDelegate, RecommendedTagsTableViewCellDataSource, RecommendedTagsTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate {
    
    var tableView: UITableView!

    var series: [Series] = []
    var tags: [Tag] = []
    var episodes: [Episode] = []
    
    let FooterHeight: CGFloat = 10
    let sectionNames = ["Tags", "Series", "Episodes"]
    let sectionHeaderHeights: [CGFloat] = [1, 32, 32]
    let sectionContentClasses: [AnyClass] = [RecommendedTagsTableViewCell.self, RecommendedSeriesTableViewCell.self, RecommendedEpisodesOuterTableViewCell.self]
    let sectionContentIndentifiers = ["TagsCell", "SeriesCell", "EpisodesCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = "Discover"
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        for (contentClass, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            tableView.register(contentClass.self, forCellReuseIdentifier: identifier)
        }
        
        tableView.backgroundColor = .paleGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        mainScrollView = tableView
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Populate with dummy data
        let s = Series()
        s.title = "Design Details"
        series = Array(repeating: s, count: 7)
        tags = [Tag(name:"Education"), Tag(name:"Politics"), Tag(name:"Doggos"),Tag(name:"Social Justice"),Tag(name:"Design Thinking"), Tag(name:"Science"),Tag(name:"Mystery")]
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.seriesID = ""
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.tags = [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")]
        episodes = Array(repeating: episode, count: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) else { return UITableViewCell() }
        if let cell = cell as? RecommendedTagsTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        } else if let cell = cell as? RecommendedSeriesTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        } else if let cell = cell as? RecommendedEpisodesOuterTableViewCell {
            cell.dataSource = self
            cell.delegate = self
            //cell.updateUIForNowPlayingEpisode(episode: Player.sharedInstance.currentEpisode)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return FooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeights[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard sectionHeaderHeights[section] != 1 else { return nil }
        let header = DiscoverTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeights[section]))
        header.configure(sectionName: sectionNames[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return RecommendedSeriesTableViewCell.recommendedSeriesTableViewCellHeight 
        case 2:
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
    
    //MARK: - RecommendedTagsTableViewCell DataSource & Delegate
    
    func recommendedTagsTableViewCell(cell: RecommendedTagsTableViewCell, dataForItemAt indexPath: IndexPath) -> Tag {
        return tags[indexPath.row]
    }
    
    func numberOfRecommendedTags(forRecommendedTagsTableViewCell cell: RecommendedTagsTableViewCell) -> Int {
        return tags.count
    }
    
    func recommendedTagsTableViewCell(cell: RecommendedTagsTableViewCell, didSelectItemAt indexPath: IndexPath) {
//        let tagViewController = TagViewController()
//        tagViewController.tag = tags[indexPath.row]
        navigationController?.pushViewController(UnimplementedViewController(), animated: true)
    }
    
    //MARK: - RecommendedEpisodesOuterTableViewCell DataSource & Delegate
    
    func recommendedEpisodesTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, dataForItemAt indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
    
    func numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell cell: RecommendedEpisodesOuterTableViewCell) -> Int {
        return episodes.count
    }
    
    func recommendedEpisodesOuterTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, didSelectItemAt indexPath: IndexPath) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episodes[indexPath.row]
        navigationController?.pushViewController(episodeViewController, animated: true)
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
    
    
    func recommendedEpisodesOuterTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode, index: Int) {
//        let tagViewController = TagViewController()
//        tagViewController.tag = episode.tags[index]
        navigationController?.pushViewController(UnimplementedViewController(), animated: true)
    }
}
