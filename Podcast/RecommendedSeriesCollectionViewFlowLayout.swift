//
//  RecommendedSeriesCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedSeriesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var CellWidth: CGFloat!
    var CellHeight: CGFloat!
    var EdgeInset: CGFloat = 8
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: 100, height: (collectionView?.frame.height)!)
        minimumLineSpacing = EdgeInset
        minimumInteritemSpacing = EdgeInset
        sectionInset = UIEdgeInsets(top: 0, left: EdgeInset, bottom: 0, right: EdgeInset)
        scrollDirection = .horizontal
    }
}
