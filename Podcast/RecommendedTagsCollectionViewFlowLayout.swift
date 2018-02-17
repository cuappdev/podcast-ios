//
//  RecommendedTopicsCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum flowLayoutType {
    case seriesDetail
    case trendingTopics
    case relatedTopics
}

class RecommendedTopicsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let edgeInset: CGFloat = 6
    let itemHeight: CGFloat = 34
    let itemWidth: CGFloat = 75
    var layoutType: flowLayoutType

    init(layoutType: flowLayoutType) {
        self.layoutType = layoutType
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()
        estimatedItemSize = CGSize(width: itemWidth, height: itemHeight)
        itemSize = UICollectionViewFlowLayoutAutomaticSize
        minimumLineSpacing = edgeInset
        scrollDirection = .horizontal

        switch layoutType {
        case .seriesDetail:
            sectionInset = .init(top: 0, left: 2 * edgeInset, bottom: 0, right: 2 * edgeInset)
        case .trendingTopics:
            sectionInset = .init(top: 0, left: 8.5 * edgeInset, bottom: 0, right: 2 * edgeInset)
        case .relatedTopics:
            sectionInset = .init(top: 0, left: 5 * edgeInset, bottom: 0, right: 2 * edgeInset)
        }
    }
}
