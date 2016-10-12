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
        
        //tableview
        feedTableView = UITableView(frame: CGRect(x: 0, y: navigationController!.navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = UIColor.podcastGrayLight
        feedTableView.separatorStyle = .none
        feedTableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        view.addSubview(feedTableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return feedEpisodes.count
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCellIdentifier") as! DiscoverTableViewCell
        cell.clickToPlayImageButton.setImage(#imageLiteral(resourceName: "fillerImage"), for: .normal)
        cell.episodeDescriptionLabel.text = "44 min • Warriors star Stephen Curry admits he’s getting annoyed by the stream of recent criticism, the possibility…"
        cell.seriesNameLabel.text = "Warriors Plus/Minus" + " • "
        cell.episodeNameLabel.text = "Stephen Curry - EP10"
        cell.episodeDateLabel.text = "Feb 26, 2016"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return DiscoverTableViewCell().height
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
