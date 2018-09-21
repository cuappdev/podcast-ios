//
//  Enclosure.swift
//  FeedKit iOS
//
//  Created by Drew Dunne on 9/18/18.
//

import Foundation

public enum Enclosure {
    // FROM APPLE: type. The type attribute provides the correct category
    // for the type of file you are using. The type values for the
    // supported file formats are: audio/x-m4a, audio/mpeg, video/quicktime,
    // video/mp4, video/x-m4v, and application/pdf.

    public enum MediaType: String {
        case m4a = "audio/x-m4a"
        case mpeg = "audio/mpeg"
        case quicktime = "video/quicktime"
        case mp4 = "video/mp4"
        case m4v = "video/x-m4v"
        case pdf = "application/pdf"
    }

    // url is asset url, length is size in bytes
    case audio(url: URL, length: Int, type: MediaType)
    case video(url: URL, length: Int, type: MediaType)
    case pdf(url: URL, length: Int)

    init?(from attributes: [String: String]) {
        guard !attributes.isEmpty,
            let typeStr = attributes["type"],
            let type = MediaType(rawValue: typeStr),
            let url = URL(string: attributes["url"] ?? ""),
            let length = Int(attributes["length"] ?? "") else {
                return nil
        }

        switch type {
        case .m4a, .mpeg:
            self = .audio(url: url, length: length, type: type)
        case .quicktime, .mp4, .m4v:
            self = .video(url: url, length: length, type: type)
        case .pdf:
            self = .pdf(url: url, length: length)
        }
        return
    }
}

extension Enclosure: Equatable {
    public static func == (lhs: Enclosure, rhs: Enclosure) -> Bool {
        switch (lhs, rhs) {
        case (.audio(let u1, let l1, let t1), .audio(let u2, let l2, let t2)):
            return u1 == u2 && l1 == l2 && t1 == t2
        case (.video(let u1, let l1, let t1), .video(let u2, let l2, let t2)):
            return u1 == u2 && l1 == l2 && t1 == t2
        case (.pdf(let u1, let l1), .pdf(let u2, let l2)):
            return u1 == u2 && l1 == l2
        default:
            return false
        }
    }
}
