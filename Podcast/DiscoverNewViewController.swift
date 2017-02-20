//
//  DiscoverNewViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecommendedSeriesTableViewCellDataSource, RecommendedSeriesTableViewCellDelegate, RecommendedTagsTableViewCellDataSource, RecommendedTagsTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate, DiscoverTableViewHeaderDelegate {
    
    var tableView: UITableView!
    
    var series: [Series] = []
    var tags: [String] = []
    var episodes: [Episode] = []
    
    let kHeaderHeight: CGFloat = 32
    let kFooterHeight: CGFloat = 10
    let sectionNames = ["Series", "Tags", "Episodes"]
    let sectionHeaderDetailShown = [true, false, false]
    let sectionHeights: [CGFloat] = [175, 80, 1000]
    let sectionContentClasses: [AnyClass] = [RecommendedSeriesTableViewCell.self, RecommendedTagsTableViewCell.self, RecommendedEpisodesOuterTableViewCell.self]
    let sectionContentIndentifiers = ["SeriesCell", "TagsCell", "EpisodesCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let searchBar = UISearchController(searchResultsController: nil) // if we want left-aligned placeholder text we may have to just use a textfield
        searchBar.searchBar.searchBarStyle = .minimal
        searchBar.searchBar.placeholder = "Search for podcasts, tags, or people"
        navigationItem.titleView = searchBar.searchBar
        searchBar.searchBar.sizeToFit()
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        for (cls, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            tableView.register(cls.self, forCellReuseIdentifier: identifier)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        // Populate with dummy data
        let u = User()
        u.name = "Spec"
        let s = Series()
        s.title = "Design Details"
        s.publisher = u
        series = Array(repeating: s, count: 7)
        tags = ["Education", "Politics", "Doggos", "Social Justice", "Design Thinking", "Science", "Mystery"]
        let e = Episode(id: 0)
        e.title = "183: Vicious Soda Can (feat. Cat Noone)"
        e.dateCreated = Date()
        e.descriptionText = "Today we caught up with Cat Noone, a designer and founder currently working jwhdaljkwh dljahwd dlkajwhd dljhaw hdjasjdhajsd hdjkalhsdjah hfhjjd"
        episodes = Array(repeating: e, count: 5)
    }
    
    //MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // don't know how to condense this using an array like the other functions
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) as! RecommendedSeriesTableViewCell
            cell.dataSource = self
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) as! RecommendedTagsTableViewCell
            cell.dataSource = self
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) as! RecommendedEpisodesOuterTableViewCell
            cell.dataSource = self
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kFooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DiscoverTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: kHeaderHeight))
        header.configure(sectionName: sectionNames[section], detailButtonShown: sectionHeaderDetailShown[section], section: section)
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sectionHeights[indexPath.section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: - RecommendedSeriesTableViewCell DataSource & Delegate
    
    func recommendedSeriesTableViewCell(dataForItemAt indexPath: IndexPath) -> Series {
        return series[indexPath.row]
    }
    
    func numberOfRecommendedSeries() -> Int {
        return series.count
    }
    
    func recommendedSeriesTableViewCell(didSelectItemAt indexPath: IndexPath) {
        print("Selected series at \(indexPath.row)")
    }
    
    //MARK: - RecommendedTagsTableViewCell DataSource & Delegate
    
    func recommendedTagsTableViewCell(dataForItemAt indexPath: IndexPath) -> String {
        return tags[indexPath.row]
    }
    
    func numberOfRecommendedTags() -> Int {
        return tags.count
    }
    
    func recommendedTagsTableViewCell(didSelectItemAt indexPath: IndexPath) {
        print("Selected tag at \(indexPath.row)")
    }
    
    //MARK: - RecommendedEpisodesOuterTableViewCell DataSource & Delegate
    
    func recommendedEpisodesTableViewCell(dataForItemAt indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
    
    func numberOfRecommendedEpisodes() -> Int {
        return episodes.count
    }
    
    func recommendedEpisodesOuterTableViewCell(didSelectItemAt indexPath: IndexPath) {
        print("Selected episode at \(indexPath.row)")
    }
    
    //MARK: - DiscoverTableViewHeader Delegate
    
    func didTapDetailButton(for section: Int) {
        if section == 0 {
            print("tapped see all series")
        }
    }
}
