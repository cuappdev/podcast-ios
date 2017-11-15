//
//  Episode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Episode: NSObject {
    
    // This should not be updated in backend or by endpoints; it is purely for local use
    var isPlaying: Bool = false
    
    var id: String
    var title: String
    var seriesID: String
    var seriesTitle: String
    var dateCreated: Date
    var descriptionText: String = "" {
        didSet {
            let modifiedFont = "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 14\">\(descriptionText)</span>"

            let attrStr = try? NSAttributedString(
                data: modifiedFont.data(using: .utf8, allowLossyConversion: true)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            attributedDescription = attrStr ?? NSAttributedString(string: "")
        }
    }
    var attributedDescription = NSAttributedString()
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var audioURL: URL?
    var duration: String
    var tags: [Tag]
    var numberOfRecommendations: Int
    var isBookmarked: Bool
    var isRecommended: Bool
    var isDownloaded: Bool = false //TODO: CHANGE
    
    //dummy data initializer - will remove in future when we have real data  
    override convenience init() {
        self.init(id: "", title: "", dateCreated: Date(), descriptionText: "", smallArtworkImageURL:nil, seriesID: "", largeArtworkImageURL: nil, audioURL: nil, duration: "1:45", seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false)
    }
    
    //all attribute initializer
    init(id: String, title: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, seriesID: String, largeArtworkImageURL: URL?, audioURL: URL?, duration: String, seriesTitle: String, tags: [Tag], numberOfRecommendations: Int, isRecommended: Bool, isBookmarked: Bool) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        if audioURL == nil { //TAKE THIS OUT LATER ONLY FOR PLAYER STATIC DATA
            self.audioURL = URL(string: "https://play.podtrac.com/npr-510298/npr.mc.tritondigital.com/NPR_510298/media/anon.npr-mp3/npr/ted/2017/02/20170215_ted_tedpod.mp3?orgId=1&d=3241&p=510298&story=515438384&t=podcast&e=515438384&ft=pod&f=510298")
        } else {
            self.audioURL = audioURL
        }
        self.seriesID = seriesID
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.tags = tags

        super.init()

        // Makes sure didSet gets called during init
        defer {
            self.descriptionText = descriptionText
        }
    }
    
    convenience init(json: JSON) {
        let id = json["id"].stringValue
        let title = json["title"].stringValue
        let dateString = json["pub_date"].stringValue
        let descriptionText = json["summary"].stringValue
        let isRecommended = json["is_recommended"].boolValue
        let isBookmarked = json["is_bookmarked"].boolValue
        let numberOfRecommendations = json["recommendations_count"].intValue
        let seriesTitle = json["series"]["title"].stringValue
        let seriesID = json["series"]["id"].stringValue
        let duration = json["duration"].stringValue
        let tags = json["tags"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag) })
        let audioURL = URL(string: json["audio_url"].stringValue)
        let dateCreated = DateFormatter.restAPIDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkURL = URL(string: json["series"]["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["series"]["image_url_lg"].stringValue)

        self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, seriesID: seriesID, largeArtworkImageURL: largeArtworkURL, audioURL: audioURL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
    }
    
    func update(json: JSON) {
        title = json["title"].stringValue
        descriptionText = json["summary"].stringValue
        isRecommended = json["is_recommended"].boolValue
        isBookmarked = json["is_bookmarked"].boolValue
        numberOfRecommendations = json["recommendations_count"].intValue
        seriesTitle = json["series"]["title"].stringValue
        seriesID = json["series"]["id"].stringValue
        duration = json["duration"].stringValue
        tags = json["tags"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag) })
        audioURL = URL(string: json["audio_url"].stringValue)
        dateCreated = DateFormatter.restAPIDateFormatter.date(from: json["pub_date"].stringValue) ?? Date()
        smallArtworkImageURL = URL(string: json["series"]["image_url_sm"].stringValue)
        largeArtworkImageURL = URL(string: json["series"]["image_url_lg"].stringValue)
    }
    
    // Returns data - time - series in a string
    func dateTimeSeriesString() -> String {
        // Check if series title is empty because some are
        return seriesTitle != "" ? "\(dateString()) • \(duration) • \(seriesTitle)" : "\(dateString()) • \(duration)"
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: dateCreated)
    }
    
    func bookmarkChange(completion: ((Bool) -> ())? = nil) {
        isBookmarked ? deleteBookmark(success: completion, failure: completion) : createBookmark(success: completion, failure: completion)
    }
    
    func recommendedChange(completion: ((Bool, Int) -> ())? = nil) {
        isRecommended ? deleteRecommendation(success: completion, failure: completion) : createRecommendation(success: completion, failure: completion)
    }
    
    func createBookmark(success: ((Bool) -> ())? = nil, failure: ((Bool) -> ())? = nil) {
        let endpointRequest = CreateBookmarkEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            self.isBookmarked = true
            success?(self.isBookmarked)
        }
        endpointRequest.failure = { _ in
            self.isBookmarked = false
            failure?(self.isBookmarked)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func deleteBookmark(success: ((Bool) -> ())? = nil, failure: ((Bool) -> ())? = nil) {
        let endpointRequest = DeleteBookmarkEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            self.isBookmarked = false
            success?(self.isBookmarked)
        }
        endpointRequest.failure = { _ in
            self.isBookmarked = true
            failure?(self.isBookmarked)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func createListeningHistory(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let endpointRequest = CreateListeningHistoryElementEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            success?()
        }
        endpointRequest.failure = { _ in
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func deleteListeningHistory(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let endpointRequest = DeleteListeningHistoryElementEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            success?()
        }
        endpointRequest.failure = { _ in
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func createRecommendation(success: ((Bool, Int) -> ())? = nil, failure: ((Bool, Int) -> ())? = nil) {
        let endpointRequest = CreateRecommendationEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            self.isRecommended = true
            self.numberOfRecommendations += 1
            success?(self.isRecommended, self.numberOfRecommendations)
        }
        endpointRequest.failure = { _ in
            self.isRecommended = false
            failure?(self.isRecommended, self.numberOfRecommendations)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func deleteRecommendation(success: ((Bool, Int) -> ())? = nil, failure: ((Bool, Int) -> ())? = nil) {
        let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            self.isRecommended = false
            self.numberOfRecommendations -= 1
            success?(self.isRecommended, self.numberOfRecommendations)
        }
        endpointRequest.failure = { _ in
            self.isRecommended = true
            failure?(self.isRecommended, self.numberOfRecommendations)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
