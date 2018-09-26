//
//  ContinueCollectionTableViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/22/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

/// UITableViewCell subclass to be used for displaying a "Continue Listening" collection view inside a table view
class ContinueTableViewCell: UITableViewCell {
    private var collectionView: UICollectionView!
    private let continueCvReuse = "continueListeningCvReuse"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //collection view layout constants
        let collectionViewItemSize = CGSize(width: 285, height: 108)
        let collectionViewSectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        let collectionViewMinimumInteritemSpacing = CGFloat(18)

        //setup flow layout using layout constants above
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = collectionViewItemSize
        layout.minimumInteritemSpacing = collectionViewMinimumInteritemSpacing
        layout.sectionInset = collectionViewSectionInset
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContinueCollectionViewCell.self, forCellWithReuseIdentifier: continueCvReuse)

        contentView.addSubview(collectionView)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    func configure(withDelegate delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, tag: Int) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = tag
        collectionView.reloadData()
    }
}
