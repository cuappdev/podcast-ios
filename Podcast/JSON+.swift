//
//  JSON+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    mutating func appendIfArray(json:JSON){
        if var arr = self.array{
            arr.append(json)
            self = JSON(arr);
        }
    }
}
