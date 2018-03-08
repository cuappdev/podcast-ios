//
//  Error+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/7/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
