//
//  SubscriptionsCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SubscriptionsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var cellWidth: CGFloat = 138
    var cellHeight: CGFloat = 168
    var edgeInset: CGFloat!
    
    override func prepare() {
        super.prepare()

        edgeInset = (UIScreen.main.bounds.width - 2 * cellWidth) / 3
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        minimumLineSpacing = edgeInset
        minimumInteritemSpacing = edgeInset
        sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
    }
}
