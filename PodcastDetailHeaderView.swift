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
    var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!
    var subscribeButton: UIButton!

    var tagsCollectionView: UICollectionView!
    var podcastGenres: [String]!

    var filterView: EpisodeFilterView!

    // MARK: - Constants
    let cellReuseId = PodcastTagsCollectionViewCell.cellReuseId
    let collectionViewEstimatedItemSize = CGSize(width: 64, height: 34)
    let collectionViewItemSize = UICollectionViewFlowLayout.automaticSize
    let collectionViewSectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
    let collectionViewMinimumInteritemSpacing = CGFloat(18)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        imageView = UIImageView()

        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        publisherLabel = UILabel()
        publisherLabel.font = .systemFont(ofSize: 16)
        publisherLabel.textColor = .gray
        publisherLabel.textAlignment = .center

        subscribeButton = UIButton()
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.titleLabel?.font = .systemFont(ofSize: 16)
        subscribeButton.backgroundColor = .recastAquamarine()
        subscribeButton.setCornerRadius(forView: .small)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = collectionViewEstimatedItemSize
        layout.itemSize = collectionViewItemSize
        layout.minimumInteritemSpacing = collectionViewMinimumInteritemSpacing
        layout.sectionInset = collectionViewSectionInset

        tagsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(PodcastTagsCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)

        filterView = EpisodeFilterView()

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(publisherLabel)
        addSubview(subscribeButton)
        addSubview(tagsCollectionView)
        addSubview(filterView)

        setUpConstraints()
    }

   func setUpConstraints() {
        // MARK: - Constants
        let imageHeight = 79
        let imageTopPadding = UIApplication.shared.statusBarFrame.height + 25
        let edgePadding = 36
        let imageBottomPadding = 16.5
        let titleHeight = 30
        let publisherHeight = 21
        let subscribeButtonPadding = 18
        let subscribeButtonSize: CGSize = .init(width: 146, height: 34)
        let collectionViewBottomPadding = 16.5
        let filterViewHeight = 46

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(imageTopPadding)
            make.height.width.equalTo(imageHeight)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(imageBottomPadding)
            make.top.greaterThanOrEqualToSuperview().offset(imageTopPadding)

            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(titleHeight)
        }

        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(publisherHeight)
            make.bottom.lessThanOrEqualToSuperview().offset(collectionViewBottomPadding)
        }

        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(subscribeButtonPadding)
            make.size.equalTo(subscribeButtonSize)
            make.centerX.equalToSuperview()
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(subscribeButtonPadding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(filterView.snp.top).inset(collectionViewBottomPadding)
        }

        filterView.snp.makeConstraints { make in
            make.height.equalTo(filterViewHeight)
            make.leading.trailing.bottom.equalToSuperview()
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
        return podcastGenres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! PodcastTagsCollectionViewCell
        cell.tagLabel.text = podcastGenres[indexPath.row]
        return cell
    }
}
