//
//  SeriesDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit
import MarqueeLabel

protocol TopicsCollectionViewDataSource: class {
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic
    func numberOfTopics(collectionView: UICollectionView) -> Int
}

protocol SeriesDetailHeaderViewDelegate: class {
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressTopicButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int)
    func seriesDetailHeaderViewDidPressMoreTopicsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: SeriesDetailHeaderView)
}

class SeriesDetailHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Constants
    static let minHeight: CGFloat = 328
    static let separatorHeight: CGFloat = 1.0
    static let topicsHeight: CGFloat = 86.0
    
    let separatorHeight: CGFloat = SeriesDetailHeaderView.separatorHeight
    let topicsHeight: CGFloat = SeriesDetailHeaderView.topicsHeight
    let padding: CGFloat = 18.0
    let imageHeight: CGFloat = 80.0
    let subscribeWidth: CGFloat = 120.0
    let subscribeHeight: CGFloat = 34.0
    let subscribeTopOffset: CGFloat = 18.0
    let topicButtonHeight: CGFloat = 34.0
    let topicButtonOuterXPadding: CGFloat = 6.0
    let topicButtonInnerXPadding: CGFloat = 12.0
    let headerViewHeight: CGFloat = 328.5
    let imageViewTopOffset: CGFloat = 24
    let titleLabelTopOffset: CGFloat = 16
    let titleLabelWidth: CGFloat = 259.5
    let titleLabelHeight: CGFloat = 30
    let publisherLabelOffset: CGFloat = 1
    let publisherLabelHeight: CGFloat = 21
    let publisherLabelInset = 20
    let viewSeparatorHeight: CGFloat = 1
    let viewSeparatorTopOffset: CGFloat = 18
    let viewSeparatorInset: CGFloat = 18
    let topicsViewTopOffset: CGFloat = 19.5
    let topicsViewHeight: CGFloat = 34
    let reuseIdentifier = "Cell"
    let episodeSeparatorHeight: CGFloat = 12
    
    var infoView: UIView!
    var gradientView: GradientView!
    var viewSeparator: UIView!
    var topicsCollectionView: UICollectionView!

    var contentContainerTop: Constraint?
    
    var contentContainer: UIView!
    var backgroundImageView: ImageView!
    var imageView: ImageView!
    var titleLabel: UILabel!
    var publisherLabel: MarqueeLabel!
    var subscribeButton: FillNumberButton!
    var settingsButton: UIButton!
    var shareButton: UIButton!
    var episodeSeparator: UIView!

    let publisherSpeed: CGFloat = 60
    let publisherTrailingBuffer: CGFloat = 10
    let publisherAnimationDelay: CGFloat = 2
    
    weak var dataSource: TopicsCollectionViewDataSource?
    weak var delegate: SeriesDetailHeaderViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .paleGrey

        contentContainer = UIView()
        contentContainer.clipsToBounds = true
        contentContainer.backgroundColor = .clear
        addSubview(contentContainer)

        backgroundImageView = ImageView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height))
        backgroundImageView.contentMode = .scaleAspectFill
        contentContainer.addSubview(backgroundImageView)

        gradientView = GradientView()
        contentContainer.addSubview(gradientView)

        infoView = UIView()
        infoView.backgroundColor = .clear
        contentContainer.addSubview(infoView)

        imageView = ImageView(frame: CGRect(x: 0.0, y: 0.0, width: imageHeight, height: imageHeight))
        infoView.addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.textColor = .offBlack
        titleLabel.font = ._20SemiboldFont()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 5
        titleLabel.lineBreakMode = .byWordWrapping
        infoView.addSubview(titleLabel)
        
        publisherLabel = MarqueeLabel(frame: .zero)
        publisherLabel.font = ._14RegularFont()
        publisherLabel.textColor = .charcoalGrey
        publisherLabel.textAlignment = .center
        publisherLabel.speed = .rate(publisherSpeed)
        publisherLabel.trailingBuffer = publisherTrailingBuffer
        publisherLabel.type = .continuous
        publisherLabel.fadeLength = publisherSpeed
        publisherLabel.tapToScroll = false
        publisherLabel.holdScrolling = true
        publisherLabel.animationDelay = publisherAnimationDelay
        infoView.addSubview(publisherLabel)
        
        subscribeButton = FillNumberButton(type: .subscribe)
        subscribeButton.addTarget(self, action: #selector(didPressSubscribeButton), for: .touchUpInside)
        infoView.addSubview(subscribeButton)
        
        shareButton = UIButton(type: .custom)
        shareButton.adjustsImageWhenHighlighted = true
        shareButton.setImage(#imageLiteral(resourceName: "iShare"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareWasPressed), for: .touchUpInside)
        
        topicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedTopicsCollectionViewFlowLayout(layoutType: .seriesDetail))
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        topicsCollectionView.register(RecommendedTopicsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        topicsCollectionView.showsHorizontalScrollIndicator = false
        topicsCollectionView.backgroundColor = .clear
        infoView.addSubview(topicsCollectionView)
        
        viewSeparator = UIView()
        viewSeparator.backgroundColor = .paleGrey
        infoView.addSubview(viewSeparator)
        
        episodeSeparator = UIView()
        episodeSeparator.backgroundColor = .paleGrey
        addSubview(episodeSeparator)
    }
    
    func setSeries(series: Series) {
        titleLabel.text = series.title
        publisherLabel.text = series.author
        topicsCollectionView.reloadData()
        subscribeButtonChangeState(isSelected: series.isSubscribed, numberOfSubscribers: series.numberOfSubscribers)
        imageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL, defaultImage: #imageLiteral(resourceName: "nullSeries"))
        backgroundImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)
        publisherLabel.holdScrolling = false
        layoutUI()
    }
    
    func layoutUI() {
        contentContainer.snp.makeConstraints { make in
            contentContainerTop = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentContainer.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(imageViewTopOffset)
            make.size.equalTo(imageHeight)
        }

        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(titleLabelTopOffset)
            make.width.equalTo(titleLabelWidth)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(publisherLabelOffset)
            make.height.equalTo(publisherLabelHeight)
            make.leading.trailing.equalToSuperview().inset(publisherLabelInset).priority(999)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(publisherLabel.snp.bottom).offset(subscribeTopOffset)
            make.width.equalTo(subscribeWidth)
            make.height.equalTo(subscribeHeight)
        }
        
        viewSeparator.snp.makeConstraints { make in
            make.height.equalTo(viewSeparatorHeight)
            make.leading.lessThanOrEqualToSuperview().offset(viewSeparatorInset)
            make.trailing.lessThanOrEqualToSuperview().inset(viewSeparatorInset)
            make.top.equalTo(subscribeButton.snp.bottom).offset(viewSeparatorTopOffset)
        }

        topicsCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(topicsViewHeight)
            make.top.equalTo(viewSeparator.snp.bottom).offset(topicsViewTopOffset)
            make.bottom.equalToSuperview().inset(topicsViewTopOffset)
        }
        
        episodeSeparator.snp.makeConstraints { make in
            make.height.equalTo(episodeSeparatorHeight)
            make.top.equalTo(contentContainer.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.seriesDetailHeaderViewDidPressTopicButton(seriesDetailHeader: self, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfTopics(collectionView: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecommendedTopicsCollectionViewCell,
            let topic = dataSource?.topicForCollectionViewCell(collectionView: collectionView, dataForItemAt: indexPath.row) else { return UICollectionViewCell() }
        cell.setup(with: topic, fontColor: .charcoalGrey)
        return cell
    }

    // MARK: - SeriesDetailHeaderViewDelegate
    
    @objc func topicButtonPressed(button: FillButton) {
        delegate?.seriesDetailHeaderViewDidPressTopicButton(seriesDetailHeader: self, index: button.tag)
    }
    
    func moreTopicsPressed() {
        delegate?.seriesDetailHeaderViewDidPressMoreTopicsButton(seriesDetailHeader: self)
    }
    
    @objc func didPressSubscribeButton() {
        delegate?.seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: self)
    }
    
    func subscribeButtonChangeState(isSelected: Bool, numberOfSubscribers: Int) {
        subscribeButton.setupWithNumber(isSelected: isSelected, numberOf: numberOfSubscribers)
    }
    
    @objc func settingsWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: self)
    }
    
    @objc func shareWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: self)
    }
    
}
