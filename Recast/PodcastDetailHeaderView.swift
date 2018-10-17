//
//  PodcastDetailHeaderView.swift
//  Recast
//
//  Created by Jack Thompson on 10/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class PodcastDetailHeaderView: UIView {

    // MARK: - Variables
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!
    var subscribeButton: UIButton!

    var tagsCollectionView: UICollectionView!

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

        subscribeButton = UIButton()
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.backgroundColor = .recastAquamarine()
        subscribeButton.setCornerRadius(forView: .small)

        tagsCollectionView = UICollectionView()
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self

        // MARK: - Test data:
        imageView.backgroundColor = .blue
        titleLabel.text = "Series Title"
        publisherLabel.text = "Publisher"

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(publisherLabel)
        addSubview(subscribeButton)
        addSubview(tagsCollectionView)

        layoutSubviews()
    }

    override func layoutSubviews() {
        // MARK: - Constants
        let imageHeight = 79
        let edgePadding = 25
        let imageBottomPadding = 16.5
        let subscribeButtonPadding = 18
        let subscribeButtonWidth = 146
        let collectionViewHeight = 100
        let collectionViewBottomPadding = 16.5

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(edgePadding)
            make.height.width.equalTo(imageHeight)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(imageBottomPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }

        publisherLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(subscribeButtonPadding)
            make.width.equalTo(subscribeButtonWidth)
            make.centerX.equalToSuperview()
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(subscribeButtonPadding)
            make.height.equalTo(collectionViewHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(collectionViewBottomPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PodcastDetailHeaderView: UICollectionViewDelegate {

}

extension PodcastDetailHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    
}
