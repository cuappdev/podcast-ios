//
//  FeedEpisodeTableViewCell.swift
//  Podcast
//
//  Created by Daniel Li on 11/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FeedSeriesTableViewCell: UITableViewCell, FeedElementTableViewCell {
    static let identifier: String = "FeedSeriesTableViewCell"

    let supplierViewHeight: CGFloat = UserSeriesSupplierView.height

    var delegate: FeedElementTableViewCellDelegate?

    var supplierView: UIView {
        return userSeriesSupplierView
    }

    var subjectView: UIView {
        return seriesSubjectView
    }

    var userSeriesSupplierView = UserSeriesSupplierView()
    var seriesSubjectView = SeriesSubjectView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        switch context {
        case .followingRecommendation, .newlyReleasedEpisode: break
        case let .followingSubscription(user, series):
            userSeriesSupplierView.setupWithUsers(users: [user], feedContext: context)
            seriesSubjectView.setupWithSeries(series: series)
        }
    }
}

