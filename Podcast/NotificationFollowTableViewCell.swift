//
//  NotificationFollowTableViewCell.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NotificationFollowTableViewCell: UITableViewCell {

    static let identifier = "NotificationFollowTableViewCell"

    var followerLabel: UILabel!
    var followerImageView: ImageView!
    var notificationDateLabel: UILabel!
    var unreadLabel: UILabel!

    let leadingTrailingOffset: CGFloat = 18
    let imageViewWidthHeight: CGFloat = 48
    let labelLeadingOffset: CGFloat = 12
    let labelTopOffset: CGFloat = 22
    let dateHeight: CGFloat = 18
    let unreadLabelWidth: CGFloat = 6

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = contentView.backgroundColor

        followerLabel = UILabel()
        followerLabel.textColor = .slateGrey
        followerLabel.numberOfLines = 0
        followerLabel.font = ._14RegularFont()
        contentView.addSubview(followerLabel)

        followerImageView = ImageView()
        followerImageView.clipsToBounds = true
        followerImageView.layer.cornerRadius = imageViewWidthHeight / 2
        contentView.addSubview(followerImageView)

        notificationDateLabel = UILabel()
        notificationDateLabel.textColor = .slateGrey
        notificationDateLabel.font = ._12RegularFont()
        contentView.addSubview(notificationDateLabel)

        unreadLabel = UILabel()
        unreadLabel.backgroundColor = .clear
        unreadLabel.addCornerRadius(height: imageViewWidthHeight)
        contentView.addSubview(unreadLabel)

        setupConstraints()
    }

    func setupConstraints() {
        followerImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(leadingTrailingOffset)
            make.width.height.equalTo(imageViewWidthHeight).priority(999)
            make.bottom.equalToSuperview().inset(leadingTrailingOffset)
        }

        followerLabel.snp.makeConstraints { make in
            make.leading.equalTo(followerImageView.snp.trailing).offset(labelLeadingOffset)
            make.top.equalToSuperview().offset(labelTopOffset)
            make.trailing.equalToSuperview().inset(leadingTrailingOffset)
        }

        notificationDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(followerLabel.snp.leading)
            make.top.equalTo(followerLabel.snp.bottom)
            make.height.equalTo(dateHeight)
        }

        unreadLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-unreadLabelWidth/2)
            make.width.equalTo(unreadLabelWidth)
            make.top.bottom.equalTo(followerImageView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for notification: NotificationActivity) {
        if notification.isUnread {
            contentView.backgroundColor = UIColor.sea.withAlphaComponent(0.1)
            unreadLabel.backgroundColor = .sea
            followerLabel.textColor = .charcoalGrey
            notificationDateLabel.textColor = .charcoalGrey
        }

        switch notification.notificationType {
        case .follow(let user):
            let attributedString = NSMutableAttributedString(string: user.fullName(), attributes: [.font : notification.isUnread ?  UIFont._14SemiboldFont() : UIFont._14RegularFont(), .foregroundColor: UIColor.offBlack])
            attributedString.append(NSAttributedString(string: " followed you"))
            followerLabel.attributedText = attributedString
            followerImageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL)
        default:
            break
        }
        notificationDateLabel.text = notification.dateString
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .offWhite
        unreadLabel.backgroundColor = .clear
        followerLabel.textColor = .slateGrey
        notificationDateLabel.textColor = .slateGrey
    }
}
