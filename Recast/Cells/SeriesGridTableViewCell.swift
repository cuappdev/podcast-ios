//
//  SeriesGridTableViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/22/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class SeriesGridTableViewCell: UITableViewCell {
    private var collectionView: UICollectionView!
    private let seriesGridReuse = "gridCvReuse"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //setup flow layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: seriesGridReuse)
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
