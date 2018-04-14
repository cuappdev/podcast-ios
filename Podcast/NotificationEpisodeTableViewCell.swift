//
//  NotificationEpisodeTableViewCell.swift
//  Podcast
//
//  Created by Mindy Lou on 4/14/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NotificationEpisodeTableViewCell: UITableViewCell {
    static let identifier = "NotificationEpisodeTableViewCell"

    var supplierLabel: UILabel!
    var notificationDateLabel: UILabel!
    var supplierImageView: ImageView!
    var episodeTitleLabel: UILabel!
    var episodeDescriptionLabel: UILabel!
    var episodeUtilityButtonBarView: EpisodeUtilityButtonBarView!
    var unreadLabel: UILabel!

    let leadingTrailingOffset: CGFloat = 18
    let imageViewWidthHeight: CGFloat = 48
    let labelLeadingOffset: CGFloat = 12
    let labelTopOffset: CGFloat = 22
    let dateHeight: CGFloat = 18
    let unreadLabelWidth: CGFloat = 6
    let episodeDetailOffset: CGFloat = 9.5
    let barButtonOffset: CGFloat = 13
    let barButtonHeight: CGFloat = 54

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .offWhite
        selectionStyle = .none

        supplierLabel = UILabel()
        supplierLabel.textColor = .charcoalGrey
        supplierLabel.numberOfLines = 0
        supplierLabel.font = ._14RegularFont()
        contentView.addSubview(supplierLabel)

        notificationDateLabel = UILabel()
        notificationDateLabel.textColor = .slateGrey
        notificationDateLabel.font = ._12RegularFont()
        contentView.addSubview(notificationDateLabel)

        supplierImageView = ImageView()
        supplierImageView.clipsToBounds = true
        contentView.addSubview(supplierImageView)

        episodeTitleLabel = UILabel()
        episodeTitleLabel.numberOfLines = 0
        episodeTitleLabel.textColor = .offBlack
        episodeTitleLabel.font = ._14RegularFont()
        contentView.addSubview(episodeTitleLabel)

        episodeDescriptionLabel = UILabel()
        episodeDescriptionLabel.textColor = .slateGrey
        episodeDescriptionLabel.font = ._12RegularFont()
        contentView.addSubview(episodeDescriptionLabel)

        unreadLabel = UILabel()
        unreadLabel.backgroundColor = .clear
        unreadLabel.addCornerRadius(height: imageViewWidthHeight)
        contentView.addSubview(unreadLabel)

        episodeUtilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        episodeUtilityButtonBarView.backgroundColor = .clear
        episodeUtilityButtonBarView.hasBottomLineSeparator = true
        episodeUtilityButtonBarView.hasTopLineSeparator = true
        contentView.addSubview(episodeUtilityButtonBarView)

        setupConstraints()
    }

    func setupConstraints() {
        supplierImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(leadingTrailingOffset)
            make.width.height.equalTo(imageViewWidthHeight)
        }

        supplierLabel.snp.makeConstraints { make in
            make.leading.equalTo(supplierImageView.snp.trailing).offset(labelLeadingOffset)
            make.trailing.equalToSuperview().inset(leadingTrailingOffset)
            make.top.equalToSuperview().offset(leadingTrailingOffset)
        }

        notificationDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(supplierLabel.snp.leading)
            make.top.equalTo(supplierLabel.snp.bottom)
            make.height.equalTo(dateHeight)
        }

        episodeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationDateLabel.snp.bottom).offset(episodeDetailOffset)
            make.leading.trailing.equalTo(notificationDateLabel)
        }

        episodeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom)
            make.leading.equalTo(episodeTitleLabel)
            make.height.equalTo(dateHeight)
        }

        unreadLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-unreadLabelWidth/2)
            make.width.equalTo(unreadLabelWidth)
            make.top.bottom.equalTo(supplierImageView)
        }

        episodeUtilityButtonBarView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(episodeDescriptionLabel.snp.bottom).offset(barButtonOffset)
            make.height.equalTo(barButtonHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for notification: NotificationActivity) {
        if !notification.hasBeenRead {
            contentView.backgroundColor = UIColor.sea.withAlphaComponent(0.1)
            unreadLabel.backgroundColor = .sea
            supplierLabel.textColor = .charcoalGrey
            episodeTitleLabel.font = ._14SemiboldFont()
            episodeDescriptionLabel.textColor = .charcoalGrey
            notificationDateLabel.textColor = .charcoalGrey
        }

        switch notification.notificationType {
        case .share(let user, let episode):
            let attributedString = NSMutableAttributedString(string: user.fullName(), attributes: [.font : notification.hasBeenRead ? UIFont._14RegularFont() : UIFont._14SemiboldFont(), .foregroundColor: UIColor.offBlack])
            attributedString.append(NSAttributedString(string: " shared an episode with you"))
            supplierLabel.attributedText = attributedString
            supplierImageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL, defaultImage: #imageLiteral(resourceName: "person"))
            supplierImageView.layer.cornerRadius = imageViewWidthHeight/2
            episodeTitleLabel.text = episode.title
            episodeDescriptionLabel.text = episode.dateTimeLabelString
            episodeUtilityButtonBarView.setup(with: episode)
            notificationDateLabel.text = notification.dateString
        // todo: add selectors and interaction
        case .newlyReleasedEpisode(let series, let episode):
            let attributedString = NSMutableAttributedString(string: series.title, attributes: [.font : notification.hasBeenRead ? UIFont._14RegularFont() : UIFont._14SemiboldFont(), .foregroundColor: UIColor.offBlack])
            attributedString.append(NSAttributedString(string: " released a new episode"))
            supplierLabel.attributedText = attributedString
            supplierImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)
            supplierImageView.addCornerRadius(height: imageViewWidthHeight)
            episodeTitleLabel.text = episode.title
            episodeDescriptionLabel.text = episode.dateTimeLabelString
            episodeUtilityButtonBarView.setup(with: episode)
            notificationDateLabel.text = episode.dateString()
        default:
            break
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .offWhite
        unreadLabel.backgroundColor = .clear
        episodeTitleLabel.textColor = .offBlack
        notificationDateLabel.textColor = .slateGrey
        supplierLabel.textColor = .charcoalGrey
        episodeDescriptionLabel.textColor = .slateGrey
    }
}
