//
//  DownloadInfo+.swift
//  Recast
//
//  Created by Mindy Lou on 9/22/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK: - DownloadInfo Entity Name Keys
extension DownloadInfo {
    struct Keys {
        static let entityName = "DownloadInfo"
        static let downloadedAt = "downloadedAt"
        static let identifier = "identifier"
        static let path = "path"
        static let progress = "progress"
        static let resumeData = "resumeData"
        static let sizeInBytes = "sizeInBytes"
        static let status = "status"
        static let episode = "episode"
    }
}

extension Episode {
    struct Keys {
        static let entityName = "EpisodeMO"
        static let downloadInfo = "downloadInfo"
    }
}

// MARK: - DownloadInfo + Core Data Properties
extension DownloadInfo {
    class func fetchRequestForIdentifier(_ identifier: Int) -> NSFetchRequest<DownloadInfo> {
        let fetchRequest = NSFetchRequest<DownloadInfo>(entityName: DownloadInfo.Keys.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(DownloadInfo.Keys.identifier) = %@", identifier)
        return fetchRequest
    }

    class func fetchDownloadInfo(with identifier: Int) -> DownloadInfo? {
        let fetchRequest = DownloadInfo.fetchRequestForIdentifier(identifier)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        do {
            let results = try appDelegate.dataController.managedObjectContext.fetch(fetchRequest)
            if let downloadInfo = results.first, results.count == 1 {
                return downloadInfo
            }
        } catch {
            print("Error fetching data from context")
        }
        return nil
    }
}

// MARK: - DownloadInfo Status
struct DownloadInfoStatus {
    static let failed = "failed"
    static let canceled = "canceled"
    static let succeeded = "succeeded"
}
