//
//  ActionSheetHeaderView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/16/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class ActionSheetHeaderView: UIView {

    var imageView: ImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!

    let episodeNameLabelY: CGFloat = 27
    let episodeNameLabelX: CGFloat = 86.5
    let episodeNameLabelRightX: CGFloat = 21
    let episodeNameLabelHeight: CGFloat = 18
    let descriptionLabelX: CGFloat = 86.5
    let descriptionLabelY: CGFloat = 47.5
    var descriptionLabelHeight: CGFloat = 14.5
    var padding: CGFloat = 18
    let smallPadding: CGFloat = 2
    var imageViewSize: CGFloat = 60

    init(frame: CGRect, image: UIImage, title: String, description: String) {
        super.init(frame: frame)

        backgroundColor = .offWhite

        imageView = ImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()

        titleLabel.font = ._14SemiboldFont()
        titleLabel.textColor = .offBlack
        titleLabel.numberOfLines = 2

        descriptionLabel.font = ._12RegularFont()
        descriptionLabel.textColor = .charcoalGrey
        descriptionLabel.numberOfLines = 2

        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().inset(padding)
            make.size.equalTo(imageViewSize)
        }

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiusPercentage * imageViewSize

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(imageView.snp.top)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(smallPadding)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
