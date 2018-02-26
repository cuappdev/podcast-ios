//
//  Tag.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class Tag: NSObject, NSCoding {
    
    var name: String
    private static let name_key = "tag_name"
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(name: "")
        if let obj = aDecoder.decodeObject(forKey: Tag.name_key) as? String {
            self.name = obj
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Tag.name_key)
    }
}
