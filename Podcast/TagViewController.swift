//
//  TagViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class TagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,RecommendedSeriesTableViewCellDelegate, RecommendedSeriesTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource, TagTableViewHeaderDelegate {
    
    private var activity: NSMutableArray?
    
    var tableView: UITableView!
    var tag: Tag!
    var episodes: [Episode] = []
    var series: [Series] = []
    
    var sectionNames = ["Top Series in ", "Top Episodes in "]
    let sectionHeaderHeight: CGFloat = 45
    let sectionContentClasses: [AnyClass] = [RecommendedSeriesTableViewCell.self, RecommendedEpisodesOuterTableViewCell.self]
    let sectionContentIndentifiers = ["SeriesCell", "EpisodesCell"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .podcastWhiteDark
        
        setupNavigationBar()
        
        for i in 0..<sectionNames.count {
            sectionNames[i] = sectionNames[i] + tag.name
        }
        
        // Instantiate tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        for (contentClass, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            tableView.register(contentClass.self, forCellReuseIdentifier: identifier)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .podcastWhiteDark
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        tableView.contentInset = UIEdgeInsetsMake(0, 0, appDelegate.tabBarController.tabBarHeight, 0)
        view.addSubview(tableView)
        
        fetchSeries()
        fetchEpisodes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    func setupNavigationBar() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: (navigationController?.navigationBar.frame.height)!))
        let titleView = UILabel(frame: CGRect.zero)
        titleView.text = tag.name
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
            cell.backgroundColor = .podcastWhiteDark
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
        let header = TagTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeight))
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
    
    //MARK - TagTableViewHeaderDelegate 
    
    func tagTableViewHeaderDidPressViewAllButton(view: TagTableViewHeader) {
        print("Pressed view all")
    }
    
    //MARK: - Endpoints 
    
    func fetchSeries() {
        let s = Series()
        s.title = "Design Details"
        s.numberOfSubscribers = 832567
        series = Array(repeating: s, count: 7)
    }
    
    func fetchEpisodes() {
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.tags = [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")]
        episodes = Array(repeating: episode, count: 5)
        
    }
}
