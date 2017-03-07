//
//  Util.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit 

class Util {
    
    //format date interval between fromDate to toDate by greatest component between
    // i.e. if fromDate: March 7, 1989  toDate: March 8, 1989 
    //      formatDateDifferenceByLargestComponent(fromDate, toDate) -> "1 day ago"
    //      if fromDate: March 9, 2015  toDate: March 8, 2017
    //      formatDateDifferenceByLargestComponent(fromDate, toDate) -> "2 years ago"
    static func formatDateDifferenceByLargestComponent(fromDate: Date, toDate: Date) -> String {
        
        let calendar = Calendar.current
        
        guard let startDays = calendar.ordinality(of: .day, in: .era, for: fromDate) else { return "" }
        guard let endDays = calendar.ordinality(of: .day, in: .era, for: toDate) else { return "" }
        let daysBetween = endDays - startDays
        
        guard let startWeek = calendar.ordinality(of: .weekday, in: .era, for: fromDate) else { return "" }
        guard let endWeek = calendar.ordinality(of: .weekday, in: .era, for: toDate) else { return "" }
        let weeksBetween = endWeek - startWeek
        
        guard let startMonth = calendar.ordinality(of: .month, in: .era, for: fromDate) else { return "" }
        guard let endMonth = calendar.ordinality(of: .month, in: .era, for: toDate) else { return "" }
        let monthsBetween = endMonth - startMonth
        
        guard let startYear = calendar.ordinality(of: .year, in: .era, for: fromDate) else { return "" }
        guard let endYear = calendar.ordinality(of: .year, in: .era, for: toDate) else { return "" }
        let yearsBetween = endYear - startYear
        
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
        return "just now"
    }
}
