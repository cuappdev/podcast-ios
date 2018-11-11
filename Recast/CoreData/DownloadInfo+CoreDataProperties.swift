//
//  DownloadInfo+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
//
//

import Foundation
import CoreData

extension DownloadInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadInfo> {
        return NSFetchRequest<DownloadInfo>(entityName: "DownloadInfo")
    }

    @NSManaged public var downloadedAt: NSDate?
    @NSManaged public var identifier: Int64
    @NSManaged public var path: String?
    @NSManaged public var progress: Float
    @NSManaged public var resumeData: NSData?
    @NSManaged public var sizeInBytes: Int32
    @NSManaged public var status: String?
    @NSManaged public var episode: Episode?

    enum Keys: String {
        case entityName = "DownloadInfo"
        case downloadedAt, identifier, path, progress, resumeData, sizeInBytes, status
        case episode
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
}
