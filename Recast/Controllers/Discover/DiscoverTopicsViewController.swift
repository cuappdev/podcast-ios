//
//  DiscoverTopicsViewController.swift
//  Recast
//
//  Created by Jack Thompson on 11/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class DiscoverTopicsViewController: ViewController {

    // MARK: - Variables
    var topicsCollectionView: UICollectionView!

    // MARK: - Constants
    let minimumInteritemSpacing: CGFloat = 20
    let collectionViewInsets = UIEdgeInsets(top: 23, left: 40, bottom: 23, right: 40)
    let reuseIdentifier = "CollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarType = .custom
        customNavBar?.title = "10-15 Minutes"
        customNavBar?.subtitle = "Gotta Go ASAP"
        customNavBar?.barColor = .red
        customNavBar?.isTranslucent = true

        view.backgroundColor = .gray

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumInteritemSpacing
        let cellWidth = (view.frame.width - collectionViewInsets.left - collectionViewInsets.right - minimumInteritemSpacing) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = collectionViewInsets

        topicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        topicsCollectionView.backgroundColor = .black
        topicsCollectionView.showsVerticalScrollIndicator = false
        topicsCollectionView.showsHorizontalScrollIndicator = false
        topicsCollectionView.register(TopicsGridCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(topicsCollectionView)

        mainScrollView = topicsCollectionView

        setUpConstraints()
    }

    func setUpConstraints() {
        topicsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - topicsCollectionView UICollectionViewDataSource
extension DiscoverTopicsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TopicsGridCollectionViewCell
        cell.topicLabel.text = "News & Politics"
        cell.backgroundColor = cell.backgroundColors[indexPath.row % 4]
        cell.backgroundTileImageView.image = #imageLiteral(resourceName: "news_tile")
        return cell
    }
}

// MARK: - topicsCollectionView UICollectionViewDataSource
extension DiscoverTopicsViewController: UICollectionViewDelegate {

}
