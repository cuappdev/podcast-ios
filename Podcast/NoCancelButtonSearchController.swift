//
//  NoCancelButtonSearchController.swift
//  Podcast
//
//  Created by Kevin Greer on 3/8/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class NoCancelButtonSearchController: UISearchController {
    
    lazy var _searchBar: NoCancelButtonSearchBar = {
        [unowned self] in
        let result = NoCancelButtonSearchBar(frame: .zero)
        
        return result
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}
