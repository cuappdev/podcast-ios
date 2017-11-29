//
//  SeriesCollectionView.swift
//  Podcast
//
//  Created by Mindy Lou on 11/21/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SeriesCollectionViewDataSource: class {
    func seriesCollectionView(seriesCollectionView: SeriesCollectionView, dataForItemAt indexPath: IndexPath) -> Series
    func numberOfRecommendedSeries(forSeriesCollectionView: SeriesCollectionView) -> Int
}

protocol SeriesCollectionViewDelegate: class {
    func seriesCollectionView(collectionView: SeriesCollectionView, didSelectItemAt indexPath: IndexPath)
}

class SeriesCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let reuseIdentifier = "Cell"
    let headerReuseIdentifier = "HeaderCell"

    weak var collectionViewDelegate: SeriesCollectionViewDelegate?
    weak var collectionViewDataSource: SeriesCollectionViewDataSource?

    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout())
        backgroundColor = .clear
        register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        showsHorizontalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource?.numberOfRecommendedSeries(forSeriesCollectionView: self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SeriesGridCollectionViewCell else { return SeriesGridCollectionViewCell() }
        guard let series = collectionViewDataSource?.seriesCollectionView(seriesCollectionView: self, dataForItemAt: indexPath) else { return SeriesGridCollectionViewCell() }
        cell.configureForSeries(series: series)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewDelegate?.seriesCollectionView(collectionView: self, didSelectItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? DiscoverCollectionViewHeader else { return DiscoverCollectionViewHeader() }
        header.frame = CGRect(x: 0, y: 0, width: frame.width, height: 25)
        header.configure(sectionName: "Series")
        return header
    }

}
