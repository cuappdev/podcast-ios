//
//  NotificationTableViewCell.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NotificationEpisodeTableViewCell: UITableViewCell {

    static let identifier = "NotificationEpisodeTableViewCell"

    var supplierLabel: UILabel!
    var supplierImageView: ImageView!
    var notificationDateLabel: UILabel!

    // for episodes only
    var episodeTitleLabel: UILabel?
    var episodeReleaseDateLabel: UILabel?
    var episodeUtilityBarButtonView: EpisodeUtilityButtonBarView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        supplierLabel = UILabel()
        supplierLabel.textColor = .charcoalGrey
        supplierLabel.font = ._14RegularFont()
        contentView.addSubview(supplierLabel)

        supplierImageView = ImageView()
        contentView.addSubview(supplierImageView)

        notificationDateLabel = UILabel()
        notificationDateLabel.textColor = .slateGrey
        notificationDateLabel.font = ._12RegularFont()
        contentView.addSubview(notificationDateLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for notification: NotificationActivity) {
        switch notification.notificationType {
        case .follow(let user):
            let attributedString = NSMutableAttributedString(string: user.fullName(), attributes: [NSAttributedStringKey.font : UIFont._14RegularFont()])
            attributedString.append(NSAttributedString(string: " followed you"))
            supplierLabel.attributedText = attributedString
            supplierImageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL, defaultImage: #imageLiteral(resourceName: "person"))
        case .newlyReleasedEpisode(let series, _): // todo: episode stuff
            let attributedString = NSMutableAttributedString(string: series.title, attributes: [NSAttributedStringKey.font : UIFont._14RegularFont()])
            attributedString.append(NSAttributedString(string: " released a new episode"))
            supplierLabel.attributedText = attributedString
            supplierImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)
        case .share(let user, _):
            let attributedString = NSMutableAttributedString(string: user.fullName(), attributes: [NSAttributedStringKey.font : UIFont._14RegularFont()])
            attributedString.append(NSAttributedString(string: " shared an episode with you"))
            supplierLabel.attributedText = attributedString
            supplierImageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL, defaultImage: #imageLiteral(resourceName: "person"))
        }
        notificationDateLabel.text = notification.dateString

        setHighlighted(!notification.hasBeenRead, animated: true)
    }

    // set highlighted to "true" if notification is new or unread
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            backgroundColor = UIColor.sea.withAlphaComponent(0.1)
        }
    }

}
