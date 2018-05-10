//
//  Episode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

struct EpisodeToUser {
    let episodeID: String
    let userID: String

    var hashValue: Int {
        return episodeID.hashValue + userID.hashValue
    }

    static func == (lhs: EpisodeToUser, rhs: EpisodeToUser) -> Bool {
        return lhs.episodeID == rhs.episodeID && lhs.userID == rhs.userID
    }
}

//var blurbs: [EpisodeToUser: String] = [:]

/// enum for our button actions, we should refactor all delegates to use these (I didn't cuz I know Drew is doing things with this)
enum EpisodeAction {
    case more
    case recast
    case bookmark
    case play // or pause
}

class Episode: NSObject, NSCoding {
    
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
    var topics: [Topic]
    var numberOfRecommendations: Int
    var isBookmarked: Bool
    var isRecommended: Bool
    var currentProgress: Double // For listening histroy duration
    var isDurationWritten: Bool // flag indicating if we have sent backend the actual episodes duration, only used when sending listening duration requests
    
    struct Keys {
        static let id = "episode_id"
        static let title = "episode_title"
        static let seriesId = "episode_seriesId"
        static let seriesTitle = "episode_seriesTitle"
        static let dateCreated = "episode_dateCreated"
        static let attrDescription = "episode_attrDescription"
        static let progress = "episode_progress"
        static let dateTimeLabelString = "episode_dateLabel"
        static let smallArtworkImageURL = "episode_smallArt"
        static let largeArtworkImageURL = "episode_largeArt"
        static let audioURL = "episode_audioURL"
        static let duration = "episode_duration"
        static let topics = "episode_topics"
        static let numberOfRecommendations = "episode_numRec"
        static let isBookmarked = "episode_bookmarked"
        static let isRecommended = "episode_recommended"
        static let isDurationWritten = "episode_durationWritten"
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        if let obj = decoder.decodeObject(forKey: Keys.id) as? String {
            self.id = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.title) as? String {
            self.title = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.seriesId) as? String {
            self.seriesID = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.seriesTitle) as? String {
            self.seriesTitle = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.dateCreated) as? Date {
            self.dateCreated = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.attrDescription) as? NSAttributedString {
            self.attributedDescription = obj
        }
        self.currentProgress = decoder.decodeDouble(forKey: Keys.progress)
        if let obj = decoder.decodeObject(forKey: Keys.dateTimeLabelString) as? String {
            self.dateTimeLabelString = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.smallArtworkImageURL) as? URL {
            self.smallArtworkImageURL = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.largeArtworkImageURL) as? URL {
            self.largeArtworkImageURL = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.audioURL) as? URL {
            self.audioURL = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.duration) as? String {
            self.duration = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.topics) as? [Topic] {
            self.topics = obj
        }
        if let obj = decoder.decodeObject(forKey: Keys.numberOfRecommendations) as? Int {
            self.numberOfRecommendations = obj
        }
        self.isBookmarked = decoder.decodeBool(forKey: Keys.isBookmarked)
        self.isRecommended = decoder.decodeBool(forKey: Keys.isRecommended)
        self.isDurationWritten = decoder.decodeBool(forKey: Keys.isDurationWritten)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id)
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(seriesID, forKey: Keys.seriesId)
        aCoder.encode(seriesTitle, forKey: Keys.seriesTitle)
        aCoder.encode(dateCreated, forKey: Keys.dateCreated)
        aCoder.encode(attributedDescription, forKey: Keys.attrDescription)
        aCoder.encode(currentProgress, forKey: Keys.progress)
        aCoder.encode(dateTimeLabelString, forKey: Keys.dateTimeLabelString)
        aCoder.encode(smallArtworkImageURL, forKey: Keys.smallArtworkImageURL)
        aCoder.encode(largeArtworkImageURL, forKey: Keys.largeArtworkImageURL)
        aCoder.encode(audioURL, forKey: Keys.audioURL)
        aCoder.encode(duration, forKey: Keys.duration)
        aCoder.encode(topics, forKey: Keys.topics)
        aCoder.encode(numberOfRecommendations, forKey: Keys.numberOfRecommendations)
        aCoder.encode(isBookmarked, forKey: Keys.isBookmarked)
        aCoder.encode(isRecommended, forKey: Keys.isRecommended)
        aCoder.encode(isDurationWritten, forKey: Keys.isDurationWritten)
    }
    
    //dummy data initializer - will remove in future when we have real data  
    override convenience init() {
        self.init(id: "", title: "", dateCreated: Date(), descriptionText: "", smallArtworkImageURL:nil, seriesID: "", largeArtworkImageURL: nil, audioURL: nil, duration: "1:45", seriesTitle: "", topics: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false, currentProgress: 0.0, isDurationWritten: false)
    }
    
    //all attribute initializer
    init(id: String, title: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, seriesID: String, largeArtworkImageURL: URL?, audioURL: URL?, duration: String, seriesTitle: String, topics: [Topic], numberOfRecommendations: Int, isRecommended: Bool, isBookmarked: Bool, currentProgress: Double, isDurationWritten: Bool) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.audioURL = audioURL
        self.seriesID = seriesID
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.topics = topics
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
        // todo? change backend tags to topics
        let topics = json["tags"].stringValue.components(separatedBy: ";").map({ topic in Topic(name: topic) })
        let audioURL = URL(string: json["audio_url"].stringValue)
        let dateCreated = DateFormatter.restAPIDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkURL = URL(string: json["series"]["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["series"]["image_url_lg"].stringValue)
        let currentProgress = json["current_progress"].doubleValue
        let isDurationWritten = json["real_duration_written"].boolValue 
        self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, seriesID: seriesID, largeArtworkImageURL: largeArtworkURL, audioURL: audioURL, duration: duration, seriesTitle: seriesTitle, topics: topics, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked, currentProgress: currentProgress, isDurationWritten: isDurationWritten)
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
        topics = json["tags"].stringValue.components(separatedBy: ";").map({ topic in Topic(name: topic) })
        audioURL = URL(string: json["audio_url"].stringValue)
        dateCreated = DateFormatter.restAPIDateFormatter.date(from: json["pub_date"].stringValue) ?? Date()
        smallArtworkImageURL = URL(string: json["series"]["image_url_sm"].stringValue)
        largeArtworkImageURL = URL(string: json["series"]["image_url_lg"].stringValue)
        currentProgress = json["current_progress"].doubleValue
        isDurationWritten = json["real_duration_written"].boolValue
        dateTimeLabelString = getDateTimeLabelString()
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
        if let user = System.currentUser, let hasRecasted = user.hasRecasted, !hasRecasted { // first recast
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
            let recastDescription = ActionSheetOption(type: .recastDescription, action: nil)
            let actionSheetViewController = ActionSheetViewController(options: [recastDescription], header: nil)
            actionSheetViewController.cancelButtonTitle = "Got it!"
            tabBarController.selectedViewController?.showActionSheetViewController(actionSheetViewController: actionSheetViewController)
        }

        let endpointRequest = CreateRecommendationEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            System.currentUser!.hasRecasted = true
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

    func dismissCurrentListeningHistory(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let endpointRequest = DismissCurrentListeningHistoryEndpointRequest(episodeID: id)
        endpointRequest.success = { _ in
            success?()
        }
        endpointRequest.failure = { _ in
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
