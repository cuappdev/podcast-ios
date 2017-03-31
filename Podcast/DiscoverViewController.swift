//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, RecommendedSeriesTableViewCellDataSource, RecommendedSeriesTableViewCellDelegate, RecommendedTagsTableViewCellDataSource, RecommendedTagsTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate, TabbedViewControllerSearchResultsControllerDelegate {
    
    var searchController: UISearchController!
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        view.backgroundColor = .white
        
        let tabbedPageViewController = TabbedPageViewController()
        tabbedPageViewController.searchResultsDelegate = self
        let searchResultsController = tabbedPageViewController
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.podcastGreenBlue]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search"
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight), style: .grouped)
        for (contentClass, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            tableView.register(contentClass.self, forCellReuseIdentifier: identifier)
        }
        tableView.backgroundColor = .podcastWhiteDark
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        
        // Populate with dummy data
        let s = Series()
        s.title = "Design Details"
        s.numberOfSubscribers = 832567
        series = Array(repeating: s, count: 7)
        tags = [Tag(name:"Education"), Tag(name:"Politics"), Tag(name:"Doggos"),Tag(name:"Social Justice"),Tag(name:"Design Thinking"), Tag(name:"Science"),Tag(name:"Mystery")]
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.seriesId = 0
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
            cell.updateUIForNowPlayingEpisode(episode: Player.sharedInstance.currentEpisode)
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
            return 150
        case 2:
            return CGFloat(episodes.count) * EpisodeTableViewCell.height
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
        
        let seriesDetailViewController = SeriesDetailViewController()
        seriesDetailViewController.series = series[indexPath.row]
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
        let tagViewController = TagViewController()
        tagViewController.tag = tags[indexPath.row]
        navigationController?.pushViewController(tagViewController, animated: true)
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
        episode.isBookmarked = !episode.isBookmarked
        episodeTableViewCell.setBookmarkButtonToState(isBookmarked: episode.isBookmarked)
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        episode.isRecommended = !episode.isRecommended
        episodeTableViewCell.setRecommendedButtonToState(isRecommended: episode.isRecommended)
    }
    
    func recommendedEpisodesOuterTableViewCellDidPressShowActionSheet(episodeTableViewCell: EpisodeTableViewCell) {
        let option1 = ActionSheetOption(title: "Download", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "shareButton"), action: nil)
        let option3 = ActionSheetOption(title: "Go to Series", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)

        var header: ActionSheetHeader?
        
        if let image = episodeTableViewCell.podcastImage.image, let title = episodeTableViewCell.episodeNameLabel.text, let description = episodeTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    
    func recommendedEpisodesOuterTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode, index: Int) {
        let tagViewController = TagViewController()
        tagViewController.tag = episode.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }
    
    //MARK: - UISearchController Delegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searchController.searchResultsController?.view.isHidden = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.searchController.searchResultsController?.view.isHidden = false
    }
    
    //MARK: - Tabbed Search Results Delegate
    func didTapOnSeriesCell(series: Series) {
        let seriesDetailViewController = SeriesDetailViewController()
        seriesDetailViewController.series = series
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
}
