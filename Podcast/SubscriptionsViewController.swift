//
//  SubscriptionsViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SubscriptionsViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EmptyStateCollectionViewDelegate {

    var subscriptionsCollectionView: EmptyStateCollectionView!
    var subscriptions: [Series] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .paleGrey
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Subscriptions"
               
        let layout = setupCollectionViewFlowLayout()
        subscriptionsCollectionView = EmptyStateCollectionView(frame: view.frame, type: .subscription, collectionViewLayout: layout)
        subscriptionsCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: "SubscriptionsCollectionViewCellIdentifier")
        subscriptionsCollectionView.delegate = self
        subscriptionsCollectionView.dataSource = self
        subscriptionsCollectionView.emptyStateCollectionViewDelegate = self
        mainScrollView = subscriptionsCollectionView
        view.addSubview(subscriptionsCollectionView)
        
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
        cell.configureForSeries(series: subscriptions[indexPath.row], showLastUpdatedText: true)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController(series: subscriptions[indexPath.row])
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
    
    func setupCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = 0.428 * view.frame.width
        let cellHeight: CGFloat = 0.315 * view.frame.height
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
            self.subscriptionsCollectionView.stopLoadingAnimation()
            self.subscriptionsCollectionView.reloadData()
        }
        
        userSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            self.subscriptionsCollectionView.stopLoadingAnimation()
        }
        
        System.endpointRequestQueue.addOperation(userSubscriptionEndpointRequest)
    }
    
    //MARK:
    //MARK: - Empty state view delegate
    //MARK:
    func emptyStateViewDidPressActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.searchTab)
    }
}
