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

            if let attrStr = try? NSMutableAttributedString(
                data: modifiedFont.data(using: .utf8, allowLossyConversion: true)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil) {
                // resize hmtl images to fit screen size
                attrStr.enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0), using: { (value, range, stop) in
                    if let attachement = value as? NSTextAttachment {
                        let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                        let screenSize: CGRect = UIScreen.main.bounds
                        if image.size.width > screenSize.width - 36 { // gives buffer of 18 padding on each side
                            let newImage = image.resizeImage(scale: (screenSize.width - 36)/image.size.width)
                            let newAttribut = NSTextAttachment()
                            newAttribut.image = newImage
                            attrStr.addAttribute(NSAttributedStringKey.attachment, value: newAttribut, range: range)
                        }
                    }
                })
                attributedDescription = attrStr
            } else {
                attributedDescription = NSAttributedString(string: "")
            }
        }
    }
    var attributedDescription = NSAttributedString()
    var dateTimeLabelString: String = "" // for cells, we store as a variable to reduce runtime during cell creation
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var audioURL: URL?
    var duration: String
    var tags: [Tag]
    var numberOfRecommendations: Int
    var isBookmarked: Bool
    var isRecommended: Bool
    var currentProgress: Double // For listening histroy duration
    var isDurationWritten: Bool // flag indicating if we have sent backend the actual episodes duration, only used when sending listening duration requests

    var isDownloaded: Bool = false //TODO: CHANGE
    
    //dummy data initializer - will remove in future when we have real data  
    override convenience init() {
        self.init(id: "", title: "", dateCreated: Date(), descriptionText: "", smallArtworkImageURL:nil, seriesID: "", largeArtworkImageURL: nil, audioURL: nil, duration: "1:45", seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false, currentProgress: 0.0, isDurationWritten: false)
    }
    
    //all attribute initializer
    init(id: String, title: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, seriesID: String, largeArtworkImageURL: URL?, audioURL: URL?, duration: String, seriesTitle: String, tags: [Tag], numberOfRecommendations: Int, isRecommended: Bool, isBookmarked: Bool, currentProgress: Double, isDurationWritten: Bool) {
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
        self.currentProgress = currentProgress
        self.isDurationWritten = isDurationWritten
        super.init()

        self.dateTimeLabelString = getDateTimeLabelString()

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
        let currentProgress = json["current_progress"].doubleValue
        let isDurationWritten = json["real_duration_written"].boolValue 
        self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, seriesID: seriesID, largeArtworkImageURL: largeArtworkURL, audioURL: audioURL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked, currentProgress: currentProgress, isDurationWritten: isDurationWritten)
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
        //NOTE: we never want to update current progress because it is locally stored until app closing
        isDurationWritten = json["real_duration_written"].boolValue
        self.dateTimeLabelString = getDateTimeLabelString()
    }

    // returns date + duration + series string with duration in hh:mm:ss format (if hours is 0 -> mm:ss)
    func getDateTimeLabelString(includeSeriesTitle: Bool = true) -> String {
        var durationString = duration
        if let exactSeconds = Double(duration), isDurationWritten {
            let seconds = Int(exactSeconds)
            let hoursMinutesSeconds = [seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60]
            durationString = hoursMinutesSeconds[0] != 0 ? "\(hoursMinutesSeconds[0]):" : ""
            durationString += hoursMinutesSeconds[1] < 10 && !durationString.isEmpty ? "0\(hoursMinutesSeconds[1]):" : "\(hoursMinutesSeconds[1]):"
            durationString += hoursMinutesSeconds[2] < 10 ? "0\(hoursMinutesSeconds[2])" : "\(hoursMinutesSeconds[2])"
        }
        return seriesTitle != "" && includeSeriesTitle ? "\(dateString()) • \(durationString) • \(seriesTitle)" : "\(dateString()) • \(durationString)"
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

    func share(with user: User, success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let endpointRequest = CreateShareEndpointRequest(episodeId: id, userSharedWithIds: [user.id])
        endpointRequest.success = { _ in
            success?()
        }
        endpointRequest.failure = { _ in
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    func deleteShare(id: String, success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let endpointRequest = DeleteShareEndpointRequest(shareId: id)
        endpointRequest.success = { _ in
            success?()
        }
        endpointRequest.failure = { _ in
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
