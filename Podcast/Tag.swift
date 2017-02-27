//
//  Tag.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class Tag: NSObject {
    
    var name = ""
    
    init(name: String = "") {
        self.name = name
        super.init()
    }
}
