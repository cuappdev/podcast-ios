//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    ///
    /// Mark: Variables
    ///
    var feedTableView: UITableView!
    var categoryCollectionView: UICollectionView!
    var feedEpisodes: [Episode] = []
    var categories: [String] = ["News","Money & Business","Politics","Music"]
    var trendingButton: UIButton!
    var trendingTagged: Bool = true
    var categoriesButton: UIButton!
    var bottomLineView: UIView!
    var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.podcastWhiteLight
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topViewHeight))
        view.addSubview(topView)
        
        //collectionview
        categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: topView.frame.height, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height), collectionViewLayout: PodcastCollectionViewFlowLayout())
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.backgroundColor = UIColor.podcastWhiteLight
        categoryCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCollectionViewIdentifier")
        view.addSubview(categoryCollectionView)
        categoryCollectionView.reloadData()
        
        //tableview
        feedTableView = UITableView(frame: CGRect(x: 0, y: topView.frame.height, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height - tabBarController!.tabBar.frame.size.height))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = UIColor.podcastWhiteLight
        feedTableView.separatorStyle = .none
        feedTableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        view.addSubview(feedTableView)
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = DiscoverTableViewCell().height
        feedTableView.reloadData()
        
        //topButtons
        bottomLineView = UIView(frame: CGRect(x: 0, y: topButtonHeight * 2 - lineHeight, width: self.view.frame.width / 2, height: lineHeight))
        bottomLineView.backgroundColor = UIColor.podcastGreenBlue
        bottomLineView.layer.cornerRadius = lineHeight / 2
        view.addSubview(bottomLineView)
        
        trendingButton = UIButton(frame: CGRect(x: 0, y: topButtonHeight, width: self.view.frame.width / 2, height: topButtonHeight))
        trendingButton.addTarget(self, action: #selector(trendingButtonPress) , for: .touchUpInside)
        trendingButton.setTitle("Trending", for: .normal)
        trendingButton.titleLabel!.font = .systemFont(ofSize: 13.0)
        trendingButton.setTitleColor(UIColor.podcastGreenBlue, for: .normal)
        view.addSubview(trendingButton)
        
        categoriesButton = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: topButtonHeight, width: self.view.frame.width / 2, height: topButtonHeight))
        categoriesButton.addTarget(self, action: #selector(categoriesButtonPress), for: .touchUpInside)
        categoriesButton.setTitle("Categories", for: .normal)
        categoriesButton.titleLabel!.font = .systemFont(ofSize: 13.0)
        categoriesButton.setTitleColor(UIColor.podcastGreenBlue, for: .normal)
        view.addSubview(categoriesButton)
        
        adjustForScreenSize()
        
        
        let series = Series()
        series.title = "Planet Money"
        
        //episode static data
        for i in 0..<4 {
            let episode = Episode(id: i)
            episode.descriptionText = "44 min • Warriors star Stephen Curry admits he’s getting annoyed by the stream of recent criticism, the possibility ... JHFJSHFGSL igsad asodhaisuhda asidgisag as hsiadgipasug siugdig asuigsi asigasidg asiugdiasgais asigdaisgd aisdgapisdg asidgaosig"
            episode.smallArtworkImage = #imageLiteral(resourceName: "fillerImage")
            episode.largeArtworkImage = #imageLiteral(resourceName: "fillerImage")
            episode.series = series
            episode.title = "Stephen Curry - EP10"
            episode.dateCreated = Date.init()
            feedEpisodes.append(episode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if trendingTagged {
            trendingButtonPress()
        } else {
            categoriesButtonPress()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: -
    //MARK: CollectionView DataSource
    //MARK: -
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewIdentifier",
                                                      for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryName = categories[indexPath.item]
        cell.layer.cornerRadius = 2.0
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(categories[indexPath.item])")
        let vc = CategoriesFeedViewController()
        vc.category = categories[indexPath.item]
        navigationController!.pushViewController(vc, animated: false)
    }
    
    
    //MARK: -
    //MARK: Top Buttons
    //MARK: -
    
    func categoriesButtonPress() {
        trendingTagged = false
        bottomLineView.frame.origin.x = self.view.frame.width / 2
        feedTableView.removeFromSuperview()
        view.addSubview(categoryCollectionView)
        categoryCollectionView.reloadData()
    }
    
    func trendingButtonPress() {
        trendingTagged = true
        bottomLineView.frame.origin.x = 0
        categoryCollectionView.removeFromSuperview()
        view.addSubview(feedTableView)
        feedTableView.reloadData()
    }
    
    func adjustForScreenSize() {
        let screenWidth = UIScreen.main.bounds.width
        
        
        if screenWidth <= 320 { //iphone 5
            trendingButton.titleLabel!.font = trendingButton.titleLabel!.font.withSize(trendingButton.titleLabel!.font.pointSize - 1)
            categoriesButton.titleLabel!.font = categoriesButton.titleLabel!.font.withSize(categoriesButton.titleLabel!.font.pointSize - 1)
        }
        
        if screenWidth >= 414 { //iphone 6/7 plus
            trendingButton.titleLabel!.font = trendingButton.titleLabel!.font.withSize(trendingButton.titleLabel!.font.pointSize + 2)
            categoriesButton.titleLabel!.font = categoriesButton.titleLabel!.font.withSize(categoriesButton.titleLabel!.font.pointSize + 2)
        }
        
    }


}
