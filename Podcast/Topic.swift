//
//  Topic.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

enum TopicType: String {
    case arts = "Arts"
    case business = "Business"
    case comedy = "Comedy"
    case education = "Education"
    case games_hobbies = "Games & Hobbies"
    case gov_org = "Government & Organizations"
    case health = "Health"
    case kids_family = "Kids & Family"
    case music = "Music"
    case news_politics = "News & Politics"
    case religion_spirituality = "Religion & Spirituality"
    case sci_med = "Science & Medicine"
    case soc_culture = "Society & Culture"
    case sports_rec = "Sports & Recreation"
    case tv_film = "TV & Film"
    case tech = "Technology"

    var image: UIImage {
        switch self {
        case .arts:
            return #imageLiteral(resourceName: "arts")
        case .business:
            return #imageLiteral(resourceName: "business")
        case .comedy:
            return #imageLiteral(resourceName: "comedy")
        case .education:
            return #imageLiteral(resourceName: "education")
        case .games_hobbies:
            return #imageLiteral(resourceName: "games_hobbies")
        case .gov_org:
            return #imageLiteral(resourceName: "government_org")
        case .health:
            return #imageLiteral(resourceName: "health")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_family")
        case .music:
            return #imageLiteral(resourceName: "music")
        case .news_politics:
            return #imageLiteral(resourceName: "news_politics")
        case .religion_spirituality:
            return #imageLiteral(resourceName: "religion_spirituality")
        case .sci_med:
            return #imageLiteral(resourceName: "science_medicine")
        case .soc_culture:
            return #imageLiteral(resourceName: "society_culture")
        case .sports_rec:
            return #imageLiteral(resourceName: "sports_recreation")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film")
        case .tech:
            return #imageLiteral(resourceName: "tech")
        }
    }

    var headerImage: UIImage {
        switch self {
        default:
            return #imageLiteral(resourceName: "comedy_header")
        }
    }
}

class Topic: NSObject {
    
    var name: String
    var id: Int?
    var subtopics: [Topic]?
    
    init(name: String, id: Int? = nil, subtopics: [Topic]? = nil) {
        self.name = name
        self.id = id
        self.subtopics = subtopics
        super.init()
    }

    convenience init(json: JSON) {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let subtopics = json["subtopics"].map{ topicJSON in Topic(json: topicJSON.1) }
        self.init(name: name, id: id, subtopics: subtopics)
    }

}
