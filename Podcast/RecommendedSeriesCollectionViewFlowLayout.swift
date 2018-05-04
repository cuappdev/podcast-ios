//
//  RecommendedSeriesCollectionViewFlowLayout.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum CollectionLayoutType {
    case discover
    case profile
    case continueListening
}

class RecommendedSeriesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    let leadingPadding: CGFloat = 18
    static let widthHeight: CGFloat = 100
    var collectionLayoutType: CollectionLayoutType

    init(layoutType: CollectionLayoutType) {
        self.collectionLayoutType = layoutType
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        scrollDirection = .horizontal

        switch(collectionLayoutType) {
        case .continueListening:
            itemSize = CGSize(width: (collectionView?.frame.width)! - 3 * leadingPadding, height: (collectionView?.frame.height)!)
            minimumInteritemSpacing = leadingPadding
            sectionInset = UIEdgeInsets(top: 0, left: leadingPadding, bottom: 0, right: leadingPadding)

        default:
            itemSize = CGSize(width: RecommendedSeriesCollectionViewFlowLayout.widthHeight, height: (collectionView?.frame.height)!)
            minimumInteritemSpacing = 6
            sectionInset = UIEdgeInsets(top: 0, left: leadingPadding, bottom: 0, right: leadingPadding)
        }
    }

}
