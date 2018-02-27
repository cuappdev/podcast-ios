//
//  Util.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit 

extension Date {
    
    //format date interval between fromDate to toDate by greatest component between
    // i.e. if fromDate: March 7, 1989  toDate: March 8, 1989 
    //      formatDateDifferenceByLargestComponent(fromDate, toDate) -> "1 day ago"
    //      if fromDate: March 9, 2015  toDate: March 8, 2017
    //      formatDateDifferenceByLargestComponent(fromDate, toDate) -> "2 years ago"
    static func formatDateDifferenceByLargestComponent(fromDate: Date, toDate: Date) -> String {
        
        let secondsBetween = Int(toDate.timeIntervalSince(fromDate))
        let hoursBetween = secondsBetween/3600
        let daysBetween = hoursBetween/24
        let weeksBetween = daysBetween/7
        let monthsBetween = daysBetween/31
        let yearsBetween = daysBetween/365
        
        if yearsBetween > 0 {
            if yearsBetween < 2 {
                return String(yearsBetween) + " year ago"
            }
            return String(yearsBetween) + " years ago"
        }
        
        if monthsBetween > 0 {
            if monthsBetween < 2 {
                return String(monthsBetween) + " month ago"
            }
            return String(monthsBetween) + " months ago"
        }
        
        if weeksBetween > 0 {
            if weeksBetween < 2 {
                return String(weeksBetween) + " week ago"
            }
            return String(weeksBetween) + " weeks ago"
        }
        
        if daysBetween > 0 {
            if daysBetween < 2 {
                return String(daysBetween) + " day ago"
            }
            return String(daysBetween) + " days ago"
        }
        
        if hoursBetween > 0 {
            if hoursBetween < 2 {
                return String(hoursBetween) + " hour ago"
            }
            return String(hoursBetween) + " hours ago"
        }
        
        return "less than an hour ago"
    }
}
