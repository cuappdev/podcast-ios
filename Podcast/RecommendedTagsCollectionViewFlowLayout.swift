//
//  RecommendedTagsCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTagsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    let edgeInset: CGFloat = 8
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: 75, height: 30)
        minimumLineSpacing = edgeInset
        minimumInteritemSpacing = edgeInset
        scrollDirection = .horizontal
        sectionInset = .zero
    }
}
