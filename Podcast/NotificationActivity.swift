//
//  NotificationActivity.swift
//  Podcast
//
//  Created by Mindy Lou on 4/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

enum NotificationType {
    case follow(User)
    case share(User, Episode)
    case newlyReleasedEpisode(String, Episode) // string placeholder for series title
}

class NotificationActivity { // because notification is in Swift already
    var notificationType: NotificationType
    var dateString = ""
    var isUnread: Bool
    var time: Date

    init(type: NotificationType, time: Date, isUnread: Bool) {
        self.notificationType = type
        self.time = time
        self.isUnread = isUnread
        self.dateString = String(Date.formatDateDifferenceByLargestComponent(fromDate: time, toDate: Date()))
    }
}
