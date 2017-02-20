//
//  RecommendedTagsTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecommendedTagsTableViewCellDataSource {
    func recommendedTagsTableViewCell(dataForItemAt indexPath: IndexPath) -> String
    func numberOfRecommendedTags() -> Int
}

protocol RecommendedTagsTableViewCellDelegate{
    func recommendedTagsTableViewCell(didSelectItemAt indexPath: IndexPath)
}

class RecommendedTagsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var dataSource: RecommendedTagsTableViewCellDataSource?
    var delegate: RecommendedTagsTableViewCellDelegate?
    
    let texts = ["Education", "Politics", "Doggos", "Social Justice", "Design Thinking", "Science", "Mystery"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: RecommendedTagsCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecommendedTagsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfRecommendedTags() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecommendedTagsCollectionViewCell
        cell.tagLabel.text = dataSource?.recommendedTagsTableViewCell(dataForItemAt: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = RecommendedTagsCollectionViewCell.CellFont
        label.text = texts[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 16, height: label.frame.height + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.recommendedTagsTableViewCell(didSelectItemAt: indexPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        collectionView.layoutSubviews()
        collectionView.setNeedsLayout()
    }
}
