//
//  SeriesHeaderView.swift
//  Recast
//
//  Created by Jack Thompson on 9/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class SeriesHeaderView: UIView {

    // MARK: - Variables
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!

    // MARK: - Constants
    let imageHeight = 100
    let topPadding = 25
    let padding = 10

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray

        imageView = UIImageView()

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        publisherLabel = UILabel()
        publisherLabel.font = .systemFont(ofSize: 16)
        publisherLabel.textAlignment = .center

        // MARK: - Test data:
        imageView.backgroundColor = .blue
        titleLabel.text = "Series Title"
        publisherLabel.text = "Publisher"

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(publisherLabel)

        layoutSubviews()
    }

    override func layoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topPadding)
            make.height.width.equalTo(imageHeight)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(padding)
            make.left.right.equalToSuperview()
        }

        publisherLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(topPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
