//
//  Int+.swift
//  Podcast
//
//  Created by Kevin Greer on 2/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation

extension Int {
    // Changes numbers from 108397878 to 108.3M
    func shortString() -> String {
        var final: Double = Double(self)
        var numberOfDivisions = 0
        while final >= 1000 {
            final /= 1000
            numberOfDivisions += 1
        }
        let suffixes = ["", "k", "M", "B", "T"]
        let suffix = numberOfDivisions < suffixes.count ? suffixes[numberOfDivisions] : ""
        // Return decimal if in thousands but less than 3 digits
        if numberOfDivisions > 0 && final < 100 {
            return "\(String(format: "%.1f", final))\(suffix)"
        }
        // Otherwise return regular digits with suffix
        return "\(String(format: "%.0f", final))\(suffix)"
    }
}
