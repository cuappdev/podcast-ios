//
//  RecommendedTopicsTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecommendedTopicsTableViewCellDataSource: class {
    func recommendedTopicsTableViewCell(cell: RecommendedTopicsTableViewCell, dataForItemAt indexPath: IndexPath) -> Topic
    func numberOfRecommendedTopics(forRecommendedTopicsTableViewCell cell: RecommendedTopicsTableViewCell) -> Int
}

protocol RecommendedTopicsTableViewCellDelegate: class {
    func recommendedTopicsTableViewCell(cell: RecommendedTopicsTableViewCell, didSelectItemAt indexPath: IndexPath)
}

class RecommendedTopicsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var iconView: ImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var collectionView: UICollectionView!
    weak var dataSource: RecommendedTopicsTableViewCellDataSource?
    weak var delegate: RecommendedTopicsTableViewCellDelegate?
    
    let TitleLabelText = "Keep informed"
    let DescriptionLabelText = "Find podcasts that everyone is currently talking about."
    let kIconViewBorderPadding: CGFloat = 20
    let kIconViewLength: CGFloat = 24
    let kIconViewContentPadding: CGFloat = 10
    let kTitleDescriptionLabelPadding: CGFloat = 8
    let kDescriptionCollectionViewPadding: CGFloat = 20
    let kCollectionViewHeight: CGFloat = 34
    let kDescriptionLabelHeight: CGFloat = 34
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconView = ImageView(frame: CGRect(x: kIconViewBorderPadding, y: kIconViewBorderPadding, width: kIconViewLength, height: kIconViewLength))
        iconView.image = #imageLiteral(resourceName: "trending")
        titleLabel = UILabel()
        titleLabel.font = ._20SemiboldFont()
        titleLabel.text = TitleLabelText
        descriptionLabel = UILabel()
        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.text = DescriptionLabelText
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .left
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedTopicsCollectionViewFlowLayout(layoutType: .trendingTopics))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecommendedTopicsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        backgroundColor = .offWhite
        contentView.addSubview(collectionView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(iconView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfRecommendedTopics(forRecommendedTopicsTableViewCell: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? RecommendedTopicsCollectionViewCell,
            let podcastTopic = dataSource?.recommendedTopicsTableViewCell(cell: self, dataForItemAt: indexPath)
            else { return UICollectionViewCell() }
        cell.setup(with: podcastTopic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = RecommendedTopicsCollectionViewCell.cellFont
        if let topic = dataSource?.recommendedTopicsTableViewCell(cell: self, dataForItemAt: indexPath) {
            label.text = topic.name
        }
        label.sizeToFit()
        return CGSize(width: label.frame.width + 16, height: label.frame.height + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.recommendedTopicsTableViewCell(cell: self, didSelectItemAt: indexPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: iconView.frame.maxX + kIconViewContentPadding, y: iconView.frame.minY, width: 0, height: 0)
        titleLabel.sizeToFit()
        descriptionLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + kTitleDescriptionLabelPadding, width: frame.width-titleLabel.frame.minX-kIconViewBorderPadding, height: kDescriptionLabelHeight)
        collectionView.frame = CGRect(x: 0, y: descriptionLabel.frame.maxY + kDescriptionCollectionViewPadding, width: frame.width, height: kCollectionViewHeight)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: titleLabel.frame.minX, bottom: 0, right: kIconViewBorderPadding)
        collectionView.layoutSubviews()
        collectionView.setNeedsLayout()
    }
}
