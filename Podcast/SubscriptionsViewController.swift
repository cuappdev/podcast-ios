//
//  SubscriptionsViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SubscriptionsViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var subscriptionsCollectionView: UICollectionView!
    var subscriptions: [Series] = []
    var loadingAnimation: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .podcastWhiteDark
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Subscriptions"
               
        let layout = setupCollectionViewFlowLayout()
        subscriptionsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        subscriptionsCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: "SubscriptionsCollectionViewCellIdentifier")
        subscriptionsCollectionView.backgroundColor = .podcastWhiteDark
        subscriptionsCollectionView.delegate = self
        subscriptionsCollectionView.dataSource = self
        subscriptionsCollectionView.showsVerticalScrollIndicator = false
        mainScrollView = subscriptionsCollectionView
        view.addSubview(subscriptionsCollectionView)
        
        loadingAnimation = createLoadingAnimationView()
        loadingAnimation.center = view.center
        view.addSubview(loadingAnimation)
        loadingAnimation.startAnimating()
        
        fetchSubscriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSubscriptions()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionsCollectionViewCellIdentifier", for: indexPath) as? SeriesGridCollectionViewCell else { return UICollectionViewCell() }
        cell.configureForSeries(series: subscriptions[indexPath.row])
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController()
        let series = subscriptions[indexPath.row]
        seriesDetailViewController.series = series
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
    
    func setupCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = 160.5
        let cellHeight: CGFloat = 210
        let edgeInset = (UIScreen.main.bounds.width - 2 * cellWidth) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = edgeInset
        layout.minimumInteritemSpacing = edgeInset
        layout.sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        return layout
    }
    
    //MARK:
    //MARK: - fetch data
    //MARK:
    

    func fetchSubscriptions() {

        guard let userID = System.currentUser?.id else { return }

        let userSubscriptionEndpointRequest = FetchUserSubscriptionsEndpointRequest(userID: userID)

        userSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let subscriptions = endpointRequest.processedResponseValue as? [Series] else { return }
            self.subscriptions = subscriptions
            self.loadingAnimation.stopAnimating()
            self.subscriptionsCollectionView.reloadData()
        }
        
        userSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            self.loadingAnimation.stopAnimating()
        }
        
        System.endpointRequestQueue.addOperation(userSubscriptionEndpointRequest)
    }
}
