//
//  FeedElementTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class FeedElementTableViewCell: UITableViewCell {

    var feedElementSubjectView: UIView! //main view
    var feedElementSupplierView: UIView! //top view
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, feedElement: FeedElement) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        feedElementSubjectView = FeedElementSubjectView(frame: CGRect.zero, feedElementContext: feedElement.context)
        feedElementSupplierView = FeedElementSupplierView(frame: CGRect.zero, feedElementContext: feedElement.context)
        addSubview(feedElementSubjectView)
        addSubview(feedElementSupplierView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
