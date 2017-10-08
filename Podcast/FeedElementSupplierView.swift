//
//  FeedElementSupplierView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit


import UIKit
import SnapKit

class FeedElementSupplierView: UIView {
    
    var mainView: UIView!
    
    init(frame: CGRect, feedElement: FeedElement) {
        super.init(frame: frame)
        switch(feedElement.context) {
        case .newlyReleasedEpisode:
            guard let series = feedElement.supplier as? Series else { return }
            mainView = SeriesFeedElementSupplierView(series: series)
        case .followingRecommendation:
            guard let user = feedElement.supplier as? User else { return }
            mainView = UserFeedElementSupplierView(users: [user])
        case .followingSubscription:
            guard let user = feedElement.supplier as? User else { return }
            mainView = UserFeedElementSupplierView(users: [user])
        }
        
        addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

