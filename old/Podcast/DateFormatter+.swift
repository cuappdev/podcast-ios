//
//  DateFormatter+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation

//Acknowledgements: code from CUAppDev Tempo 
extension DateFormatter {
    
    @nonobjc static let parsingDateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        $0.timeZone = TimeZone(secondsFromGMT: 0)
        $0.locale = Locale(identifier: "en_US")
        return $0
    }(DateFormatter())
    
    @nonobjc static let restAPIDateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+zz:zz"
        $0.timeZone = TimeZone(secondsFromGMT: 0)
        $0.locale = Locale(identifier: "en_US")
        return $0
    }(DateFormatter())
    
    @nonobjc static let simpleDateFormatter: DateFormatter = {
        $0.dateFormat = "M.dd.YY"
        return $0
    }(DateFormatter())
    
    @nonobjc static let yearMonthDayFormatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd"
        $0.locale = Locale(identifier: "en_US_POSIX")
        return $0
    }(DateFormatter())
    
    @nonobjc static let slashYearMonthDayFormatter: DateFormatter = {
        $0.dateFormat = "yyyy/MM/dd"
        $0.locale = Locale(identifier: "en_US_POSIX")
        return $0
    }(DateFormatter())
    
    @nonobjc static let monthFormatter: DateFormatter = {
        $0.dateFormat = "MMM"
        return $0
    }(DateFormatter())
    
    @nonobjc static let postHistoryDateFormatter: DateFormatter = {
        $0.dateFormat = "MMM d, yyyy"
        $0.locale = Locale(identifier: "en_US_POSIX")
        return $0
    }(DateFormatter())
    
}
