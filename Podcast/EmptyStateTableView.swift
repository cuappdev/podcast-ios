//
//  EmptyStateTableView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EmptyStateTableViewDelegate: class {
    func didPressEmptyStateViewActionItem()
}

/**
 UITableView Subclass with predefined styles and an empty state view shown when no cells are in this tableView for all sections
 */
class EmptyStateTableView: UITableView, EmptyStateViewDelegate {
    
    var type: EmptyStateType
    var emptyStateView: EmptyStateView!
    weak var emptyStateTableViewDelegate: EmptyStateTableViewDelegate?
    
    init(withType type: EmptyStateType) {
        self.type = type
        super.init(frame: .zero, style: .plain)
        emptyStateView = EmptyStateView(type: type)
        emptyStateView.delegate = self
        backgroundView = emptyStateView
        backgroundView?.isHidden = true 
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // make sure there is no data in tableView before displaying background
        for s in 0..<numberOfSections {
            if numberOfRows(inSection: s) > 0 {
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
        emptyStateTableViewDelegate?.didPressEmptyStateViewActionItem()
    }
    
    
}
