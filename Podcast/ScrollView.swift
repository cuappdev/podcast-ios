//
//  ScrollView.swift
//  Podcast
//
//  Created by Mindy Lou on 11/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    var contentHeight: CGFloat

    override init(frame: CGRect) {
        contentHeight = 0
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(collectionView: UICollectionView, height: CGFloat) {
        addSubview(collectionView)
        contentHeight += height
    }

    func add(tableView: UITableView) {
        addSubview(tableView)
    }

    func add(customView: UIView, height: CGFloat) {
        addSubview(customView)
        contentHeight += height 
    }

}
