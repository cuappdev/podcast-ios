//
//  FeedEpisodeTableViewCell.swift
//  Podcast
//
//  Created by Daniel Li on 11/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FeedEpisodeTableViewCell: UITableViewCell, FeedElementTableViewCell {
    static let identifier: String = "FeedEpisodeTableViewCell"

    let supplierViewHeight: CGFloat = UserSeriesSupplierView.height

    var delegate: FeedElementTableViewCellDelegate?

    var supplierView: UIView {
        return userSeriesSupplierView
    }

    var subjectView: UIView {
        return episodeSubjectView
    }

    var userSeriesSupplierView = UserSeriesSupplierView()
    var episodeSubjectView = EpisodeSubjectView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        switch context {
        case let .followingRecommendation(user, episode):
            userSeriesSupplierView.setupWithUsers(users: [user], feedContext: context)
            episodeSubjectView.setupWithEpisode(episode: episode)
            
        case let .newlyReleasedEpisode(series, episode):
            userSeriesSupplierView.setupWithSeries(series: series)
            episodeSubjectView.setupWithEpisode(episode: episode)
        case .followingSubscription: break
        }
    }
}
