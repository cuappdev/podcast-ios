//
//  SubscriptionsViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SubscriptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    var subscriptionsCollectionView: UICollectionView!
    var subscriptions: [Series] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .podcastWhiteDark
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.titleTextAttributes = UIFont.navigationBarDefaultFontAttributes
        title = "Subscriptions"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       
        subscriptionsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - appDelegate.tabBarController.tabBarHeight), collectionViewLayout: SubscriptionsCollectionViewFlowLayout())
        subscriptionsCollectionView.register(RecommendedSeriesCollectionViewCell.self, forCellWithReuseIdentifier: "SubscriptionsCollectionViewCellIdentifier")
        subscriptionsCollectionView.backgroundColor = .podcastWhiteDark
        subscriptionsCollectionView.delegate = self
        subscriptionsCollectionView.dataSource = self
        subscriptionsCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(subscriptionsCollectionView)
        
        subscriptions = fetchSubscriptions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK
    //MARK: - Collection View Setup
    //MARK
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionsCollectionViewCellIdentifier", for: indexPath) as! RecommendedSeriesCollectionViewCell
        cell.configure(series: subscriptions[indexPath.row])
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController()
        seriesDetailViewController.series = subscriptions[indexPath.row]
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
    
    //MARK:
    //MARK: - fetch data
    //MARK:
    
    func fetchSubscriptions() -> [Series] {
        //dummy data
        var series: [Series] = []
        for i in 0..<9{
            let s = Series(id: i, title: "Design Details", author: "IDK", descriptionText: "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are.", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")], numberOfSubscribers: 32023, isSubscribed: true)
            series.append(s)
        }
        return series
    }
}
