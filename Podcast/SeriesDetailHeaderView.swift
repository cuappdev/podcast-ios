//
//  SeriesDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol TagsCollectionViewDataSource: class {
    func tagForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Tag
    func numberOfTags(collectionView: UICollectionView) -> Int
}

protocol SeriesDetailHeaderViewDelegate: class {
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int)
    func seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: SeriesDetailHeaderView)
}

class SeriesDetailHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Constants
    static let minHeight: CGFloat = 308
    static let separatorHeight: CGFloat = 1.0
    static let tagsHeight: CGFloat = 86.0
    
    let separatorHeight: CGFloat = SeriesDetailHeaderView.separatorHeight
    let tagsHeight: CGFloat = SeriesDetailHeaderView.tagsHeight
    let padding: CGFloat = 18.0
    let imageHeight: CGFloat = 80.0
    let subscribeWidth: CGFloat = 97.0
    let subscribeHeight: CGFloat = 34.0
    let subscribeTopOffset: CGFloat = 18.0
    let tagButtonHeight: CGFloat = 34.0
    let tagButtonOuterXPadding: CGFloat = 6.0
    let tagButtonInnerXPadding: CGFloat = 12.0
    let headerViewHeight: CGFloat = 308.5
    let imageViewTopOffset: CGFloat = 24
    let titleLabelTopOffset: CGFloat = 16
    let titleLabelWidth: CGFloat = 259.5
    let titleLabelHeight: CGFloat = 30
    let publisherLabelOffset: CGFloat = 1
    let publisherLabelHeight: CGFloat = 21
    let viewSeparatorHeight: CGFloat = 1
    let viewSeparatorTopOffset: CGFloat = 18
    let viewSeparatorInset: CGFloat = 18
    let tagsViewTopOffset: CGFloat = 19.5
    let tagsViewHeight: CGFloat = 34
    let reuseIdentifier = "Cell"
    
    var infoView: UIView!
    var viewSeparator: UIView!
    var tagsCollectionView: UICollectionView!
    
    // Contain all Series information, not accessible outside, set through series variable
    var backgroundImageView: ImageView!
    var imageView: ImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!
    var subscribeButton: FillButton!
    var settingsButton: UIButton!
    var shareButton: UIButton!
    
    weak var dataSource: TagsCollectionViewDataSource?
    weak var delegate: SeriesDetailHeaderViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        infoView = UIView()
        infoView.backgroundColor = .offWhite
        infoView.clipsToBounds = true
        
        backgroundImageView = ImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: headerViewHeight))
        backgroundImageView.contentMode = .scaleAspectFill

        imageView = ImageView(frame: CGRect(x: 0, y: 0, width: imageHeight, height: imageHeight))
        
        let gradientView = GradientView(frame: frame)
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .offBlack
        titleLabel.font = ._20SemiboldFont()
        titleLabel.textAlignment = .center
        
        publisherLabel = UILabel(frame: .zero)
        publisherLabel.font = ._14RegularFont()
        publisherLabel.textColor = .charcoalGrey
        publisherLabel.textAlignment = .center
        
        subscribeButton = FillButton(type: .subscribe)
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitle("Subscribed", for: .selected)
        subscribeButton.addTarget(self, action: #selector(didPressSubscribeButton), for: .touchUpInside)
        
        shareButton = UIButton(type: .custom)
        shareButton.adjustsImageWhenHighlighted = true
        shareButton.setImage(#imageLiteral(resourceName: "shareButton"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareWasPressed), for: .touchUpInside)
        
        tagsCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: RecommendedTagsCollectionViewFlowLayout())
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(RecommendedTagsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.backgroundColor = .clear
        
        viewSeparator = UIView()
        viewSeparator.backgroundColor = .paleGrey

        infoView.addSubview(backgroundImageView)
        infoView.addSubview(gradientView)
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(subscribeButton)
        infoView.addSubview(publisherLabel)
        infoView.addSubview(tagsCollectionView)
        infoView.addSubview(viewSeparator)
        
        addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(imageViewTopOffset)
            make.size.equalTo(imageHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(titleLabelTopOffset)
            make.width.equalTo(titleLabelWidth)
            make.height.equalTo(titleLabelHeight)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(publisherLabelOffset)
            make.height.equalTo(publisherLabelHeight)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(publisherLabel.snp.bottom).offset(subscribeTopOffset)
            make.width.equalTo(subscribeWidth)
            make.height.equalTo(subscribeHeight)
        }
        
        viewSeparator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(viewSeparatorHeight)
            make.width.equalToSuperview().inset(viewSeparatorInset)
            make.top.equalTo(subscribeButton.snp.bottom).offset(viewSeparatorTopOffset)
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(tagsViewHeight)
            make.top.equalTo(viewSeparator.snp.bottom).offset(tagsViewTopOffset)
        }
        tagsCollectionView.contentInset = UIEdgeInsets(top: 0, left: viewSeparatorInset, bottom: 0, right: 0)
        tagsCollectionView.layoutSubviews()
        tagsCollectionView.setNeedsLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSeries(series: Series) {
        titleLabel.text = series.title
        publisherLabel.text = series.author
        tagsCollectionView.reloadData()
        subscribeButtonChangeState(isSelected: series.isSubscribed)

        imageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL, defaultImage: #imageLiteral(resourceName: "nullSeries"))
        backgroundImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: self, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfTags(collectionView: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecommendedTagsCollectionViewCell,
            let tag = dataSource?.tagForCollectionViewCell(collectionView: collectionView, dataForItemAt: indexPath.row) else { return UICollectionViewCell() }
        cell.setup(with: tag, fontColor: .charcoalGrey)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagButton = FillButton(type: .tag)
        guard let tag = dataSource?.tagForCollectionViewCell(collectionView: collectionView, dataForItemAt: indexPath.row) else { return CGSize() }
        tagButton.setTitle(tag.name, for: .normal)
        tagButton.sizeToFit()
        return CGSize(width: tagButton.frame.width + 2 * tagButtonInnerXPadding, height: tagButtonHeight)
    }
    
    // MARK: - SeriesDetailHeaderViewDelegate
    
    @objc func tagButtonPressed(button: FillButton) {
        delegate?.seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: self, index: button.tag)
    }
    
    func moreTagsPressed() {
        delegate?.seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: self)
    }
    
    @objc func didPressSubscribeButton() {
        delegate?.seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: self)
    }
    
    func subscribeButtonChangeState(isSelected: Bool) {
        subscribeButton.isSelected = isSelected
    }
    
    @objc func settingsWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: self)
    }
    
    @objc func shareWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: self)
    }
    
}
