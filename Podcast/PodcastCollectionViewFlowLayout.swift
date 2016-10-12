//
//  PodcastCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/2/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PodcastCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var CellWidth: CGFloat!
    var CellHeight: CGFloat!
    var EdgeInset: CGFloat = 15
    
    override func prepare() {
        super.prepare()
    
        CellWidth = (UIScreen.main.bounds.width - EdgeInset * 3) / 2
        CellHeight = CellWidth * 0.70
        itemSize = CGSize(width: CellWidth, height: CellHeight)
        minimumLineSpacing = EdgeInset
        minimumInteritemSpacing = EdgeInset
        sectionInset = UIEdgeInsets(top: EdgeInset, left: EdgeInset, bottom: EdgeInset, right: EdgeInset)
    }
}
