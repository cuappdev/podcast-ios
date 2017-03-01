//
//  Int+.swift
//  Podcast
//
//  Created by Kevin Greer on 2/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation

extension Int {
    func shortString() -> String {
        if self > 1000000 {
            return "\(self / 1000000)m"
        } else if self > 1000 {
            return "\(self / 1000)k"
        }
        return "\(self)"
    }
}
