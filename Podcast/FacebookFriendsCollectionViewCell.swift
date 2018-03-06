//
//  FacebookFriendsCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/17/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import SnapKit
import UIKit

protocol FacebookFriendsCollectionViewCellDelegate: class {
    func facebookFriendCollectionViewCellDidPressFollowButton(cell: FacebookFriendsCollectionViewCell)
}

class FacebookFriendsCollectionViewCell: UICollectionViewCell {

    static let cellHeight: CGFloat = 185
    static let cellWidth: CGFloat = 133

    let imagePadding: CGFloat = 18
    let smallPadding: CGFloat = 3
    let largePadding: CGFloat = 8
    let imageSize: CGFloat = 60
    let buttonWidth: CGFloat = 97
    let buttonHeight: CGFloat = 34

    var imageView: ImageView!
    var titleLabel: UILabel!
    var detailsLabel: UILabel!
    var button: FillButton!
    weak var delegate: FacebookFriendsCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .offWhite

        imageView = ImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.offWhite.cgColor
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        addSubview(imageView)

        titleLabel = UILabel(frame: .zero)
        addSubview(titleLabel)

        detailsLabel = UILabel(frame: .zero)
        addSubview(detailsLabel)

        titleLabel.font = ._14SemiboldFont()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .offBlack
        titleLabel.textAlignment = .center

        detailsLabel.font = ._12RegularFont()
        detailsLabel.textColor = .slateGrey
        detailsLabel.textAlignment = .center
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.numberOfLines = 1

        button = FillButton(type: .followWhite)
        button.setTitle("Follow", for: .normal)
        button.setTitle("Following", for: .selected)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didPressFollowButton), for: .touchUpInside)
        addSubview(button)

        imageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(imagePadding)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(largePadding)
            make.leading.trailing.equalToSuperview().inset(smallPadding)
            make.centerX.equalToSuperview()
        }

        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(smallPadding)
            make.leading.trailing.centerX.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).offset(largePadding)
            make.leading.trailing.equalToSuperview().inset(imagePadding)
            make.width.greaterThanOrEqualTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }

        snp.makeConstraints { make in
            make.width.equalTo(FacebookFriendsCollectionViewCell.cellWidth)
            make.height.equalTo(FacebookFriendsCollectionViewCell.cellHeight)
        }
    }

    func configureForUser(user: User) {
        imageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL, defaultImage: #imageLiteral(resourceName: "person"))
        titleLabel.text = user.fullName()
        detailsLabel.text = user.numberOfFollowers == 1 ? "\(user.numberOfFollowers.shortString()) follower" : "\(user.numberOfFollowers.shortString()) followers"
        button.isSelected = user.isFollowing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didPressFollowButton() {
        delegate?.facebookFriendCollectionViewCellDidPressFollowButton(cell: self)
    }

    func setFollowButtonState(isFollowing: Bool, numberOfFollowers: Int) {
        detailsLabel.text = numberOfFollowers == 1 ? "\(numberOfFollowers.shortString()) follower" : "\(numberOfFollowers.shortString()) followers"
        button.isSelected = isFollowing
    }
}

