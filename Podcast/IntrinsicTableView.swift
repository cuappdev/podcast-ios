//
//  IntrinsicTableView.swift
//  Podcast
//
//  Created by Mindy Lou on 2/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

class IntrinisicTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }

}
