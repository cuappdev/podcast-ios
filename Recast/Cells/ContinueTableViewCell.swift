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
        //setup flow layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 285, height: 108)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContinueCollectionViewCell.self, forCellWithReuseIdentifier: continueCvReuse)
        
        contentView.addSubview(collectionView)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setUpConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
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
