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
        view.backgroundColor = UIColor.podcastGrayLight
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topViewHeight))
        view.addSubview(topView)
        
        //collectionview
        categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: topView.frame.height, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height), collectionViewLayout: PodcastCollectionViewFlowLayout())
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.backgroundColor = UIColor.podcastGrayLight
        categoryCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCollectionViewIdentifier")
        view.addSubview(categoryCollectionView)
        categoryCollectionView.reloadData()
        
        //tableview
        feedTableView = UITableView(frame: CGRect(x: 0, y: topView.frame.height, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = UIColor.podcastGrayLight
        feedTableView.separatorStyle = .none
        feedTableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        view.addSubview(feedTableView)
        feedTableView.reloadData()
        
        //topButtons
        bottomLineView = UIView(frame: CGRect(x: 0, y: topButtonHeight * 2 - lineHeight, width: self.view.frame.width / 2, height: lineHeight))
        bottomLineView.backgroundColor = UIColor.black
        bottomLineView.layer.cornerRadius = lineHeight / 2
        view.addSubview(bottomLineView)
        
        trendingButton = UIButton(frame: CGRect(x: 0, y: topButtonHeight, width: self.view.frame.width / 2, height: topButtonHeight))
        trendingButton.addTarget(self, action: #selector(trendingButtonPress) , for: .touchUpInside)
        trendingButton.setTitle("Trending", for: .normal)
        trendingButton.titleLabel!.font = .systemFont(ofSize: 13.0)
        trendingButton.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(trendingButton)
        
        categoriesButton = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: topButtonHeight, width: self.view.frame.width / 2, height: topButtonHeight))
        categoriesButton.addTarget(self, action: #selector(categoriesButtonPress), for: .touchUpInside)
        categoriesButton.setTitle("Categories", for: .normal)
        categoriesButton.titleLabel!.font = .systemFont(ofSize: 13.0)
        categoriesButton.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(categoriesButton)
        
        adjustForScreenSize()
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
        cell.categoryName = categories[indexPath.row]
        cell.layer.cornerRadius = 2.0
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("selected \(categories[indexPath.row])")
        let vc = CategoriesFeedViewController()
        vc.category = categories[indexPath.row]
        navigationController?.pushViewController(vc, animated: false)
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
