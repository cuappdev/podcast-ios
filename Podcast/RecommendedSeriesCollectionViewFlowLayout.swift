//
//  RecommendedSeriesCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedSeriesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    let leadingPadding: CGFloat = 18
    let widthHeight: CGFloat = 100
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: widthHeight, height: (collectionView?.frame.height)!)
        minimumInteritemSpacing = 6
        sectionInset = .init(top: 0, left: -(collectionView?.frame.width)! + leadingPadding, bottom: 0, right: 0) // weird bug
        scrollDirection = .horizontal
        sectionHeadersPinToVisibleBounds = true
    }

}
