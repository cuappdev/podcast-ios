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

// MARK: - DownloadInfo + Core Data Properties
extension DownloadInfo {
    class func fetchRequestForIdentifier(_ identifier: Int) -> NSFetchRequest<DownloadInfo> {
        let fetchRequest: NSFetchRequest<DownloadInfo> = DownloadInfo.fetchRequest()
        // swiftlint:disable:next compiler_protocol_init
        fetchRequest.predicate = NSPredicate(format: "\(DownloadInfo.Keys.identifier.rawValue) == %@", NSNumber(integerLiteral: identifier))
        return fetchRequest
    }

    class func fetchDownloadInfo(with identifier: Int) -> DownloadInfo? {
        let fetchRequest = DownloadInfo.fetchRequestForIdentifier(identifier)
        do {
            let results = try AppDelegate.appDelegate.dataController.childManagedObjectContext.fetch(fetchRequest)
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
    static let downloading = "downloading"
}
