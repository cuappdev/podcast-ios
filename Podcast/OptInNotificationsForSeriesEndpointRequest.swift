//
//  OptInNotificationsForSeriesEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 5/2/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Endpoint request to opt in for notifications for a given series.
/// Should be made when tapping the bell icon on series detail views.
class OptInNotificationsForSeriesEndpointRequest: EndpointRequest {

    init(seriesID: String) {
        super.init()
        httpMethod = .post
        path = "/notifications/episodes/\(seriesID)/"
    }

}

/// Endpoint request to opt out for notifications for a given series.
/// Should be made when tapping the bell icon on series detail views.
class OptOutNotificationsForSeriesEndpointRequest: EndpointRequest {
    init(seriesID: String) {
        super.init()
        httpMethod = .delete
        path = "/notifications/episodes/\(seriesID)/"
    }
}
