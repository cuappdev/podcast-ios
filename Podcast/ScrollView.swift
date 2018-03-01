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
    var contentView: UIView!

    override init(frame: CGRect) {
        contentHeight = 0
        contentView = UIView()
        super.init(frame: frame)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            make.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(collectionView: UICollectionView, height: CGFloat) {
        contentView.addSubview(collectionView)
        contentHeight += height
    }

    func add(tableView: UITableView) {
        contentView.addSubview(tableView)
    }

    func add(customView: UIView, height: CGFloat) {
        contentView.addSubview(customView)
        contentHeight += height
    }

}
