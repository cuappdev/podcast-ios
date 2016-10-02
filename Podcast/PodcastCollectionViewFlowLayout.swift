//
//  PodcastCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/2/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PodcastCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var CellWidth: CGFloat = 165
    var CellHeight: CGFloat = 120
    var EdgeInset: CGFloat = 15
    
    override func prepare() {
        super.prepare()
    
        itemSize = CGSize(width: CellWidth, height: CellHeight)
        minimumLineSpacing = EdgeInset
        minimumInteritemSpacing = EdgeInset
        sectionInset = UIEdgeInsets(top: EdgeInset, left: EdgeInset, bottom: EdgeInset, right: EdgeInset)
    }
}
