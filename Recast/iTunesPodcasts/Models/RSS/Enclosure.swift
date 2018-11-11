//
//  Enclosure.swift
//  FeedKit iOS
//
//  Created by Drew Dunne on 9/18/18.
//

import Foundation

extension Enclosure {

    public enum MediaType: Int64 {
        case m4a, mpeg, quicktime, mp4, m4v, pdf

        init?(from string: String) {
            if string == "audio/x-m4a" {
                self = .m4a
            } else if string == "audio/mpeg" {
                self = .mpeg
            } else if string == "video/quicktime" {
                self = .quicktime
            } else if string == "video/mp4" {
                self = .mp4
            } else if string == "video/x-m4v" {
                self = .m4v
            } else if string == "application/pdf" {
                self = .pdf
            } else {
                return nil
            }
        }
    }

    convenience init?(from attributes: [String: String]) {
        guard !attributes.isEmpty,
            let typeStr = attributes["type"],
            let type = MediaType(from: typeStr)?.rawValue,
            let url = URL(string: attributes["url"] ?? ""),
            let length = Int64(attributes["length"] ?? "") else {
                return nil
        }
        self.init(context: AppDelegate.appDelegate.dataController.managedObjectContext)
        setValue(url, for: .url)
        setValue(length, for: .length)
        setValue(type, for: .type)
    }

    public static func == (lhs: Enclosure, rhs: Enclosure) -> Bool {
        return lhs.url == rhs.url && lhs.length == rhs.length && lhs.type == rhs.type
    }
}
