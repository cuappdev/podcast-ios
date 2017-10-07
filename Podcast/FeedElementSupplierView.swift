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
    
    init(frame: CGRect, feedElementContext: FeedContext) {
        super.init(frame: frame)
        switch(feedElementContext) {
        case .newlyReleasedEpisode:
            mainView = SeriesFeedElementSupplierView()
        case .followingRecommendation:
            mainView = UserFeedElementSupplierView()
        case .followingSubscription:
            mainView = UserFeedElementSupplierView()
        default:
            break
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

