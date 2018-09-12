//
//  SeriesProtocols.swift
//  Podcast
//
//  Created by Mindy Lou on 9/9/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class SeriesDisplayTableViewCell: UITableViewCell {
    weak var displayView: SeriesDisplayView!
}

class SeriesDisplayCollectionViewCell: UICollectionViewCell {
    weak var displayView: SeriesDisplayView!
}

protocol SeriesDisplayView: class {
    func set(title: String)
    func set(author: String)
    func set(topicsString: String)
    func set(lastUpdated: String)
    func set(numberOfSubscribers: Int, isSubscribed: Bool)

    func set(largeImageUrl: URL)
    func set(smallImageUrl: URL)

    // Note: this function is only used in internal profile
    // If you have any other ideas on how to remove this more efficiently please let me know
    func hideSubscribedButton()
}

// TODO mindylou: tableview/collectionview data source
// This will likely be complicated because series are usually displayed with a combination of other stuff (esp. with collection views)
