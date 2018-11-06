//
//  ContinueCollectionTableViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/22/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

/// UICollectionViewCell subclass to be used for displaying a "Continue Listening" collection view inside a table view
//swiftlint:disable:next type_name
class HomeContinueListeningCollectionViewCell: UICollectionViewCell {
    var collectionView: UICollectionView!
    private let continueCvReuse = "continueListeningCvReuse"

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        // MARK: Collection view layout constants
        let collectionViewMinimumInteritemSpacing = CGFloat(18)

        //setup flow layout using layout constants above
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = collectionViewMinimumInteritemSpacing
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContinueListeningCollectionViewCell.self, forCellWithReuseIdentifier: continueCvReuse)

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
