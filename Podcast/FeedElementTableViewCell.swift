//
//  FeedElementTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class FeedElementTableViewCell: UITableViewCell {

    var feedElementSubjectView: FeedElementSubjectView! //main view
    var feedElementSupplierView: FeedElementSupplierView! //top view
    
    var newlyReleasedEpisodeSupplierViewHeight: CGFloat = SupplierView.height
    var followingSubscriptionSupplierViewHieght: CGFloat = SupplierView.height
    var followingRecommendationSupplierViewHeight: CGFloat = SupplierView.height
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupWithFeedElement(feedElement: FeedElement) {
        
        var heightConstraint: CGFloat!
        
        switch feedElement.context {
        case .followingRecommendation:
            guard let user = feedElement.supplier as? User, let episode = feedElement.subject as? Episode else { return }
            feedElementSupplierView = SupplierView(supplier: [user])
            feedElementSubjectView = EpisodeSubjectView(episode: episode)
            heightConstraint = followingRecommendationSupplierViewHeight
        case .followingSubscription:
            guard let user = feedElement.supplier as? User, let series = feedElement.subject as? Series else { return }
            feedElementSupplierView = SupplierView(supplier: [user])
            feedElementSubjectView = SeriesSubjectView() //TODO: implement
            heightConstraint = followingSubscriptionSupplierViewHieght
        case .newlyReleasedEpisode:
            guard let series = feedElement.supplier as? Series, let episode = feedElement.subject as? Episode else { return }
            feedElementSupplierView = SupplierView(supplier: series)
            feedElementSubjectView = EpisodeSubjectView(episode: episode)
            heightConstraint = newlyReleasedEpisodeSupplierViewHeight
        }
        
        addSubview(feedElementSubjectView)
        addSubview(feedElementSupplierView)
        
        feedElementSupplierView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(heightConstraint)
        }
        
        feedElementSubjectView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(feedElementSupplierView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
