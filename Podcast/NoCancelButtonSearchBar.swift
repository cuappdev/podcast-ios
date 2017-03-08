//
//  NoCancelButtonSearchBar.swift
//  Podcast
//
//  Created by Kevin Greer on 3/8/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class NoCancelButtonSearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
}
