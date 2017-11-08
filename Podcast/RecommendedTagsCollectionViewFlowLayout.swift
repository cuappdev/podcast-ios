//
//  RecommendedTagsCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTagsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let edgeInset: CGFloat = 6
    let itemHeight: CGFloat = 34
    let itemWidth: CGFloat = 75
    
    override func prepare() {
        super.prepare()
        estimatedItemSize = CGSize(width: itemWidth, height: itemHeight)
        itemSize = UICollectionViewFlowLayoutAutomaticSize
        minimumLineSpacing = edgeInset
        minimumInteritemSpacing = edgeInset
        scrollDirection = .horizontal
        sectionInset = .init(top: 0, left: 2 * edgeInset, bottom: 0, right: 2 * edgeInset)
    }
}
