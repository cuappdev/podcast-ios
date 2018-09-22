//
//  DataModelKeys.swift
//  Recast
//
//  Created by Mindy Lou on 9/22/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import CoreData

extension DownloadInfo {
    struct Keys {
        static let entityName = "DownloadInfo"
        static let downloadedAt = "downloadedAt"
        static let path = "path"
        static let progress = "progress"
        static let resumeData = "resumeData"
        static let sizeInBytes = "sizeInBytes"
        static let status = "status"
    }
}

enum DownloadInfoStatus: String {
    case failed = "failed"
    case canceled = "canceled"
    case succeeded = "succeeded"
}
