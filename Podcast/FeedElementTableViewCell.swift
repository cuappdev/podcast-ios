//
//  FeedElementTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol FeedElementTableViewCellDelegate: class {
    func feedElementTableViewCellDidPressEpisodeSubjectViewMoreButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView)
    func feedElementTableViewCellDidPressEpisodeSubjectViewPlayPauseButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView)
    func feedElementTableViewCellDidPressEpisodeSubjectViewBookmarkButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView)
    func feedElementTableViewCellDidPressEpisodeSubjectViewTagButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView, index: Int)
    func feedElementTableViewCellDidPressEpisodeSubjectViewRecommendedButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView)
    func feedElementTableViewCellDidPressSupplierViewFeedControlButton(feedElementTableViewCell: FeedElementTableViewCell, supplierView: UserSeriesSupplierView)
}

class FeedElementTableViewCell: UITableViewCell, EpisodeSubjectViewDelegate, SupplierViewDelegate {
    
    var feedElementSubjectView: FeedElementSubjectView! //main view
    var feedElementSupplierView: FeedElementSupplierView! //top view
    
    var newlyReleasedEpisodeSupplierViewHeight: CGFloat = UserSeriesSupplierView.height
    var followingSubscriptionSupplierViewHieght: CGFloat = UserSeriesSupplierView.height
    var followingRecommendationSupplierViewHeight: CGFloat = UserSeriesSupplierView.height
    
    weak var delegate: FeedElementTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    func setupWithFeedElement(feedElement: FeedElement) {
        
        var heightConstraint: CGFloat!
        
        switch feedElement.context {
        case .followingRecommendation:
            guard let user = feedElement.supplier as? User, let episode = feedElement.subject as? Episode else { return }
            feedElementSupplierView = UserSeriesSupplierView(supplier: [user])
            (feedElementSupplierView as! UserSeriesSupplierView).delegate = self
            feedElementSubjectView = EpisodeSubjectView(episode: episode)
            (feedElementSubjectView as! EpisodeSubjectView).delegate = self
            heightConstraint = followingRecommendationSupplierViewHeight
        case .followingSubscription:
            guard let user = feedElement.supplier as? User, let series = feedElement.subject as? Series else { return }
            feedElementSupplierView = UserSeriesSupplierView(supplier: [user])
            (feedElementSupplierView as! UserSeriesSupplierView).delegate = self
            feedElementSubjectView = SeriesSubjectView(series: series)
            //(feedElementSubjectView as! SeriesSubjectView).delegate = self
            heightConstraint = followingSubscriptionSupplierViewHieght
        case .newlyReleasedEpisode:
            guard let series = feedElement.supplier as? Series, let episode = feedElement.subject as? Episode else { return }
            feedElementSupplierView = UserSeriesSupplierView(supplier: series)
            (feedElementSupplierView as! UserSeriesSupplierView).delegate = self
            feedElementSubjectView = EpisodeSubjectView(episode: episode)
            (feedElementSubjectView as! EpisodeSubjectView).delegate = self
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
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func supplierViewDidPressFeedControlButton(supplierView: UserSeriesSupplierView) {
        delegate?.feedElementTableViewCellDidPressSupplierViewFeedControlButton(feedElementTableViewCell: self, supplierView: supplierView)
    }
    
    func episodeSubjectViewDidPressPlayPauseButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.feedElementTableViewCellDidPressEpisodeSubjectViewPlayPauseButton(feedElementTableViewCell: self, episodeSubjectView: episodeSubjectView)
    }
    
    func episodeSubjectViewDidPressRecommendButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.feedElementTableViewCellDidPressEpisodeSubjectViewRecommendedButton(feedElementTableViewCell: self, episodeSubjectView: episodeSubjectView)
    }
    
    func episodeSubjectViewDidPressBookmarkButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.feedElementTableViewCellDidPressEpisodeSubjectViewBookmarkButton(feedElementTableViewCell: self, episodeSubjectView: episodeSubjectView)
    }
    
    func episodeSubjectViewDidPressTagButton(episodeSubjectView: EpisodeSubjectView, index: Int) {
        delegate?.feedElementTableViewCellDidPressEpisodeSubjectViewTagButton(feedElementTableViewCell: self, episodeSubjectView: episodeSubjectView, index: index)
    }
    
    func episodeSubjectViewDidPressMoreActionsButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.feedElementTableViewCellDidPressEpisodeSubjectViewMoreButton(feedElementTableViewCell: self, episodeSubjectView: episodeSubjectView)
    }
}
