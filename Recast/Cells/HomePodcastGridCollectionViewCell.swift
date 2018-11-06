//
//  SeriesGridTableViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/22/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

// swiftlint:disable:next type_name
class HomePodcastGridCollectionViewCell: UICollectionViewCell {
    // MARK: View vars
    var collectionView: UICollectionView!

    // MARK: CV reuse identifier
    private let seriesGridReuse = "gridCvReuse"

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        //collection view layout constants
        let collectionViewMinimumInteritemSpacing = CGFloat(12)

        //setup flow layout using layout constants above
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = collectionViewMinimumInteritemSpacing
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PodcastGridCollectionViewCell.self, forCellWithReuseIdentifier: seriesGridReuse)
        contentView.addSubview(collectionView)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Constraint setup
    private func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

}
