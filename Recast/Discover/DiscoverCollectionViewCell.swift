//
//  DiscoverCollectionViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 11/10/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    var faceImageView: UIImageView!
    var durationDescriptionLabel: UILabel!
    var minutesLabel: UILabel!

    static var faceImageHeight: CGFloat = 98.5

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .black

        faceImageView = UIImageView()
        faceImageView.contentMode = .scaleAspectFit
        contentView.addSubview(faceImageView)

        durationDescriptionLabel = UILabel()
        durationDescriptionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        durationDescriptionLabel.textColor = .white
        durationDescriptionLabel.textAlignment = .center
        contentView.addSubview(durationDescriptionLabel)

        minutesLabel = UILabel()
        minutesLabel.font = .systemFont(ofSize: 18)
        minutesLabel.textColor = .lightGray
        minutesLabel.textAlignment = .center
        contentView.addSubview(minutesLabel)

        setUpConstraints()
    }

    func setUpConstraints() {
        let faceImageHeight: CGFloat = 280
        let faceImageDurationDescriptionLabelVerticalSpacing: CGFloat = 16
        let durationDescriptionLabelMinutesLabelVerticalSpacing: CGFloat = 8

        faceImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(faceImageHeight)
            make.centerX.equalToSuperview()
        }

        durationDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(faceImageView.snp.bottom).offset(faceImageDurationDescriptionLabelVerticalSpacing)
            make.centerX.equalToSuperview()
        }

        minutesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(durationDescriptionLabel.snp.bottom).offset(durationDescriptionLabelMinutesLabelVerticalSpacing)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
