//
//  EmptyStateCollectionView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/28/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EmptyStateCollectionViewDelegate: class {
    func emptyStateViewDidPressActionItem()
}

class EmptyStateCollectionView: UICollectionView, EmptyStateViewDelegate  {

    var type: EmptyStateType
    var emptyStateView: EmptyStateView!
    weak var emptyStateCollectionViewDelegate: EmptyStateCollectionViewDelegate?
    
    init(withType type: EmptyStateType, collectionViewLayout: UICollectionViewLayout) {
        self.type = type
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        emptyStateView = EmptyStateView(type: type)
        emptyStateView.delegate = self
        backgroundView = emptyStateView
        backgroundView?.isHidden = true
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // make sure there is no data in tableView before displaying background
        for s in 0..<numberOfSections {
            if numberOfItems(inSection: s) > 0 {
                backgroundView?.isHidden = true
                return
            }
        }
        backgroundView?.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didPressActionItemButton() {
        emptyStateCollectionViewDelegate?.emptyStateViewDidPressActionItem()
    }

}
