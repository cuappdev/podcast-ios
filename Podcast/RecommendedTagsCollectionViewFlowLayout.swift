//
//  RecommendedTagsCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTagsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var CellWidth: CGFloat!
    var CellHeight: CGFloat!
    var EdgeInset: CGFloat = 8
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: 75, height: 30)
        minimumLineSpacing = EdgeInset
        minimumInteritemSpacing = EdgeInset
        scrollDirection = .horizontal
        sectionInset = .zero
    }
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElements(in: rect)
//        
//        var leftMargin = sectionInset.left
//        var maxY: CGFloat = -1.0
//        attributes?.forEach { layoutAttribute in
//            if layoutAttribute.frame.origin.y >= maxY {
//                leftMargin = sectionInset.left
//            }
//            
//            layoutAttribute.frame.origin.x = leftMargin
//            
//            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
//            maxY = max(layoutAttribute.frame.maxY , maxY)
//        }
//        
//        return attributes
//    }
}
