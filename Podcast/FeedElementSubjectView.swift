//
//  FeedElementSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit 

class FeedElementSubjectView: UIView {
    
    var mainView: UIView!
    
    init(frame: CGRect, feedElement: FeedElement) {
        super.init(frame: frame)
        switch(feedElement.context) {
        case .newlyReleasedEpisode:
            guard let episode = feedElement.subject as? Episode else { return }
            mainView = EpisodeSubjectView(episode: episode)
        case .followingRecommendation:
            guard let episode = feedElement.subject as? Episode else { return }
            mainView = EpisodeSubjectView(episode: episode)
        case .followingSubscription:
            guard let series = feedElement.subject as? Series else { return }
            mainView = SeriesSubjectView()
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
