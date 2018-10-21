//
//  Enclosure.swift
//  FeedKit iOS
//
//  Created by Drew Dunne on 9/18/18.
//

import Foundation

//public enum Enclosure {
    // FROM APPLE: type. The type attribute provides the correct category
//    // for the type of file you are using. The type values for the
//    // supported file formats are: audio/x-m4a, audio/mpeg, video/quicktime,
//    // video/mp4, video/x-m4v, and application/pdf.
//
//    public enum MediaType: String {
//        case m4a = "audio/x-m4a"
//        case mpeg = "audio/mpeg"
//        case quicktime = "video/quicktime"
//        case mp4 = "video/mp4"
//        case m4v = "video/x-m4v"
//        case pdf = "application/pdf"
//    }
//
//    // url is asset url, length is size in bytes
//    case audio(url: URL, length: Int, type: MediaType)
//    case video(url: URL, length: Int, type: MediaType)
//    case pdf(url: URL, length: Int)
//
//    init?(from attributes: [String: String]) {
//        guard !attributes.isEmpty,
//            let typeStr = attributes["type"],
//            let type = MediaType(rawValue: typeStr),
//            let url = URL(string: attributes["url"] ?? ""),
//            let length = Int(attributes["length"] ?? "") else {
//                return nil
//        }
//
//        switch type {
//        case .m4a, .mpeg:
//            self = .audio(url: url, length: length, type: type)
//        case .quicktime, .mp4, .m4v:
//            self = .video(url: url, length: length, type: type)
//        case .pdf:
//            self = .pdf(url: url, length: length)
//        }
//        return
//    }
//
//    func getURL() -> URL? {
//        switch self {
//        case .audio(let url, _, _):
//            return url
//        default:
//            return nil
//        }
//    }
//}

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
            }
            return nil
        }
    }

    convenience init?(from attributes: [String: String]) {
        guard !attributes.isEmpty,
            let typeStr = attributes["type"],
            let type = MediaType(from: typeStr),
            let url = URL(string: attributes["url"] ?? ""),
            let length = Int64(attributes["length"] ?? "") else {
                return nil
        }
        self.init()
        self.url = url
        self.length = length
        self.type = type.rawValue
    }

    public static func == (lhs: Enclosure, rhs: Enclosure) -> Bool {
        return lhs.url == rhs.url && lhs.length == rhs.length && lhs.type == rhs.type
    }
}
