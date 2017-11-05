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
    func feedElementTableViewCellDidPressSeriesSubjectViewSubscribeButton(feedElementTableViewCell: FeedElementTableViewCell, seriesSubjectView: SeriesSubjectView)
}

class FeedElementTableViewCell: UITableViewCell, EpisodeSubjectViewDelegate, SupplierViewDelegate, SeriesSubjectViewDelegate {
    
    var feedElementSubjectView: FeedElementSubjectView = EpisodeSubjectView() //main view
    var feedElementSupplierView: FeedElementSupplierView = UserSeriesSupplierView() //top view
    
    var newlyReleasedEpisodeSupplierViewHeight: CGFloat = UserSeriesSupplierView.height
    var followingSubscriptionSupplierViewHeight: CGFloat = UserSeriesSupplierView.height
    var followingRecommendationSupplierViewHeight: CGFloat = UserSeriesSupplierView.height
    var heightConstraint: CGFloat = 0.0
    
    weak var delegate: FeedElementTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(feedElementSubjectView)
        contentView.addSubview(feedElementSupplierView)

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
    
    func setupWithFeedElement(feedElement: FeedElement) {

        contentView.subviews.forEach { $0.removeFromSuperview() }
        switch feedElement.context {
        case let .followingRecommendation(user, episode):
            feedElementSupplierView = UserSeriesSupplierView()
            (feedElementSupplierView as! UserSeriesSupplierView).setupWithUsers(users: [user], feedContext: feedElement.context)
            (feedElementSupplierView as! UserSeriesSupplierView).delegate = self
            feedElementSubjectView = EpisodeSubjectView(episode: episode)
            (feedElementSubjectView as! EpisodeSubjectView).delegate = self
            heightConstraint = followingRecommendationSupplierViewHeight
        case let .followingSubscription(user, series):
            feedElementSupplierView = UserSeriesSupplierView()
            (feedElementSupplierView as! UserSeriesSupplierView).setupWithUsers(users: [user], feedContext: feedElement.context)
            (feedElementSupplierView as! UserSeriesSupplierView).delegate = self
            feedElementSubjectView = SeriesSubjectView(series: series)
            (feedElementSubjectView as! SeriesSubjectView).delegate = self
            heightConstraint = followingSubscriptionSupplierViewHeight
        case let .newlyReleasedEpisode(series, episode):
            feedElementSupplierView = UserSeriesSupplierView()
            (feedElementSupplierView as! UserSeriesSupplierView).setupWithSeries(series: series)
            (feedElementSupplierView as! UserSeriesSupplierView).delegate = self
            feedElementSubjectView = EpisodeSubjectView(episode: episode)
            (feedElementSubjectView as! EpisodeSubjectView).delegate = self
            heightConstraint = newlyReleasedEpisodeSupplierViewHeight
        }

        contentView.addSubview(feedElementSubjectView)
        contentView.addSubview(feedElementSupplierView)

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
    
    func seriesSubjectViewDidPressSubscribeButton(seriesSubjectView: SeriesSubjectView) {
        delegate?.feedElementTableViewCellDidPressSeriesSubjectViewSubscribeButton(feedElementTableViewCell: self, seriesSubjectView: seriesSubjectView)
    }
}
