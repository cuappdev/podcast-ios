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
    case newlyReleasedEpisode(Series, Episode)
}

class NotificationActivity { // because notification is in Swift already
    var notificationType: NotificationType
    var dateString = ""
    var hasBeenRead: Bool
    var time: Date

    init(type: NotificationType, time: Date, hasBeenRead: Bool) {
        self.notificationType = type
        self.time = time
        self.hasBeenRead = hasBeenRead
        self.dateString = String(Date.formatDateDifferenceByLargestComponent(fromDate: time, toDate: Date()))
    }
}
