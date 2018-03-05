//
//  RecommendedSeriesTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecommendedSeriesTableViewCellDataSource: class {
    func recommendedSeriesTableViewCell(dataForItemAt indexPath: IndexPath) -> Series?
    func numberOfRecommendedSeries() -> Int?
    func getUser() -> User?
}

protocol RecommendedSeriesTableViewCellDelegate: class {
    func recommendedSeriesTableViewCell(cell: UICollectionViewCell, didSelectItemAt indexPath: IndexPath)
}

class RecommendedSeriesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var recommendedSeriesTableViewCellHeight: CGFloat = 165
    
    var collectionView: UICollectionView!
    weak var dataSource: RecommendedSeriesTableViewCellDataSource?
    weak var delegate: RecommendedSeriesTableViewCellDelegate?
    
    let cellIdentifier = "Cell"
    let nullCellIdentifier = "NullCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        backgroundColor = .clear
        collectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(NullProfileCollectionViewCell.self, forCellWithReuseIdentifier: nullCellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
    }
    
    // Reloads the cell's inner collection view
    func reloadCollectionViewData() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numSeries = dataSource?.numberOfRecommendedSeries() {
            return max (1, numSeries)
        }
        else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let numSeries = dataSource?.numberOfRecommendedSeries() else { return UICollectionViewCell() }
        
        if numSeries > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SeriesGridCollectionViewCell else { return SeriesGridCollectionViewCell() }
            guard let series = dataSource?.recommendedSeriesTableViewCell(dataForItemAt: indexPath) else { return SeriesGridCollectionViewCell() }
            cell.configureForSeries(series: series)
            return cell
        }
        else {
            guard let user = dataSource?.getUser() else { return UICollectionViewCell() }
            //check null cell,
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nullCellIdentifier, for: indexPath) as? NullProfileCollectionViewCell else { return NullProfileCollectionViewCell() }
            cell.setUp(user: user)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            delegate?.recommendedSeriesTableViewCell(cell: cell, didSelectItemAt: indexPath)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        collectionView.layoutSubviews()
        collectionView.setNeedsLayout()
    }
}
