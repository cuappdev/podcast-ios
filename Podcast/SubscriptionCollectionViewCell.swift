//
//  SubscriptionCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SubscriptionCollectionViewCell: RecommendedSeriesCollectionViewCell {
    
    override func configure(series: Series) {
        super.configure(series: series)
        subscribersLabel.text = "Last updated " + Util.formatDateDifferenceByLargestComponent(fromDate: series.lastUpdated, toDate: Date())
    }
}
