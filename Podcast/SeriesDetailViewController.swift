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
    let sectionTitleH: CGFloat = 18.0
    let padding: CGFloat = 18.0
    let sepH: CGFloat = 1.0
    
    var seriesHeaderView: SeriesDetailHeaderView!
    var epsiodeTableView: UITableView!
    
    var series: Series? {
        didSet {
            updateViewData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        // Do any additional setup after loading the view.
        let s = Series()
        s.title = "Dog Pods"
        s.desc = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        s.largeArtworkImage = UIImage(named: "fillerImage")
        s.publisher = "Dog Lovers"
        s.tags = ["Design", "Learning", "User Experience", "Technology", "Innovation", "Dogs"]
        let episode = Episode(id: 0)
        episode.title = "Puppies Galore"
        episode.series = s
        episode.dateCreated = Date()
        episode.smallArtworkImage = #imageLiteral(resourceName: "fillerImage")
        episode.descriptionText = "Fun with dogs!"
        episode.tags = ["Design", "Learning", "User Experience", "Technology", "Innovation", "Dogs"]
        s.episodes = [episode]
        series = s
    }
    
    func createSubviews() {
        let sframe = CGRect(x: 0, y:0, width: view.frame.width, height: seriesHeaderHeight)
        seriesHeaderView = SeriesDetailHeaderView(frame: sframe)
        seriesHeaderView.delegate = self
        
        let tframe = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        epsiodeTableView = UITableView(frame: tframe, style: .plain)
        epsiodeTableView.delegate = self
        epsiodeTableView.dataSource = self
        epsiodeTableView.tableHeaderView = seriesHeaderView
        epsiodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCellIdentifier")
        epsiodeTableView.reloadData()
        
        view.addSubview(epsiodeTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewData() {
        guard let series = series else { return }
        seriesHeaderView.updateViewWithSeries(series: series)
        navigationItem.title = series.title
        epsiodeTableView.reloadData()
    }
    
    func subscribeButtonPressed(subscribed: Bool) {
        
    }
    
    func tagButtonPressed(index: Int) {
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let series = series else { return 0 }
        return series.episodes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCellIdentifier") as! EpisodeTableViewCell
        cell.delegate = self
        guard let series = series else {
            return cell
        }
        cell.setupWithEpisode(episode: series.episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EpisodeTableViewCell().height
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
        sectionTitle.frame = CGRect(x: padding, y: sectionTitleY, width: sectionTitle.frame.width, height: sectionTitleH)
        
        view.addSubview(sectionTitle)
        
        let sep1 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        let sep2 = UIView(frame: CGRect(x: 0, y: view.frame.height - sepH, width: view.frame.width, height: 1))
        sep1.backgroundColor = .podcastGray
        sep2.backgroundColor = .podcastGray
        
        view.addSubview(sep1)
        view.addSubview(sep2)
        
        tableView.sendSubview(toBack: view)
    }
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        
    }
    
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        
    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
