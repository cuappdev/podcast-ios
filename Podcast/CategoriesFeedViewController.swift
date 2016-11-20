//
//  CategoriesFeedViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/12/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//
import UIKit

class CategoriesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    ///
    /// Mark: Variables
    ///
    var feedTableView: UITableView!
    var feedEpisodes: [Episode] = []
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        //tableview
        feedTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = .podcastWhiteDark
        feedTableView.separatorStyle = .none
        feedTableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        feedTableView.estimatedRowHeight = DiscoverTableViewCell().height
        view.addSubview(feedTableView)
        
        let series = Series()
        series.title = "Planet Money"
        
        //episode static data
        for i in 0..<4 {
            let episode = Episode(id: i, title: "Stephen Curry - EP10", dateCreated: Date(), descriptionText: "44 min • In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.")
            episode.series = series
            feedEpisodes.append(episode)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = category
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    
    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCellIdentifier") as! DiscoverTableViewCell
        cell.episode = feedEpisodes[indexPath.row]
        cell.layoutSubviews()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = feedTableView.cellForRow(at: indexPath) as? DiscoverTableViewCell else { return }
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
        
    }
    
}
