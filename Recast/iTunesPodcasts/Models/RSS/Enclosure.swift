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
    
    // url is asset url, length is size in bytes
    case audio(url: URL, length: Int)
    case video(url: URL, length: Int)
    case pdf(url: URL, length: Int)
    
    init?(from attributes: [String : String]) {
        guard !attributes.isEmpty,
            let type = attributes["type"],
            let url = URL(string: attributes["url"] ?? ""),
            let length = Int(attributes["length"] ?? "") else {
                return nil
        }
        
        let audio_types = ["audio/x-m4a", "audio/mpeg"]
        let video_types = ["video/quicktime", "video/mp4", "video/x-m4v"]
        let pdf_types = ["application/pdf"]
        if audio_types.contains(type)  {
            self = .audio(url: url, length: length)
            return
        } else if video_types.contains(type) {
            self = .video(url: url, length: length)
            return
        } else if pdf_types.contains(type) {
            self = .pdf(url: url, length: length)
            return
        }
        return nil
    }
}

extension Enclosure: Equatable {
    public static func ==(lhs: Enclosure, rhs: Enclosure) -> Bool {
        switch (lhs, rhs) {
        case (.audio(let u1, let l1), .audio(let u2, let l2)):
            return u1 == u2 && l1 == l2
        case (.video(let u1, let l1), .video(let u2, let l2)):
            return u1 == u2 && l1 == l2
        case (.pdf(let u1, let l1), .pdf(let u2, let l2)):
            return u1 == u2 && l1 == l2
        default:
            return false
        }
    }
}
