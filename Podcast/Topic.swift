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
            return #imageLiteral(resourceName: "arts_icon")
        case .business:
            return #imageLiteral(resourceName: "business_icon")
        case .comedy:
            return #imageLiteral(resourceName: "comedy_icon")
        case .education:
            return #imageLiteral(resourceName: "education_icon")
        case .games_hobbies:
            return #imageLiteral(resourceName: "games_hobbies_icon")
        case .gov_org:
            return #imageLiteral(resourceName: "government_icon")
        case .health:
            return #imageLiteral(resourceName: "health_icon")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_icon")
        case .music:
            return #imageLiteral(resourceName: "music_icon")
        case .news_politics:
            return #imageLiteral(resourceName: "news_politics_icon")
        case .religion_spirituality:
            return #imageLiteral(resourceName: "religion_icon")
        case .sci_med:
            return #imageLiteral(resourceName: "science_icon")
        case .soc_culture:
            return #imageLiteral(resourceName: "society_culture_icon")
        case .sports_rec:
            return #imageLiteral(resourceName: "sports_icon")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film_icon")
        case .tech:
            return #imageLiteral(resourceName: "tech_icon")
        }
    }

    var headerImage: UIImage {
        switch self {
        case .arts:
            return #imageLiteral(resourceName: "art_header")
        case .business:
            return #imageLiteral(resourceName: "business_header")
        case .comedy:
            return #imageLiteral(resourceName: "comedy_header")
        case .education:
            return #imageLiteral(resourceName: "education_header")
        case .games_hobbies:
            return #imageLiteral(resourceName: "games_header")
        case .gov_org:
            return #imageLiteral(resourceName: "government_header")
        case .health:
            return #imageLiteral(resourceName: "health_header")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_header")
        case .music:
            return #imageLiteral(resourceName: "music_header")
        case .news_politics:
            return #imageLiteral(resourceName: "news_politics_header")
        case .religion_spirituality:
            return #imageLiteral(resourceName: "religion_header")
        case .sci_med:
            return #imageLiteral(resourceName: "science_header")
        case .soc_culture:
            return #imageLiteral(resourceName: "society_culture_header")
        case .sports_rec:
            return #imageLiteral(resourceName: "sports_header")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film_header")
        case .tech:
            return #imageLiteral(resourceName: "tech_header")
        }
    }

    var tileImage: UIImage {
        switch self {
        case .arts:
            return #imageLiteral(resourceName: "arts_tile")
        case .business:
            return #imageLiteral(resourceName: "business_tile")
        case .comedy:
            return #imageLiteral(resourceName: "comedy_tile")
        case .education:
            return #imageLiteral(resourceName: "education_tile")
        case .games_hobbies:
            return #imageLiteral(resourceName: "games_tile")
        case .gov_org:
            return #imageLiteral(resourceName: "government_tile")
        case .health:
            return #imageLiteral(resourceName: "health_tile")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_tile")
        case .music:
            return #imageLiteral(resourceName: "music_tile")
        case .news_politics:
            return #imageLiteral(resourceName: "news_tile")
        case .religion_spirituality:
            return #imageLiteral(resourceName: "religion_tile")
        case .sci_med:
            return #imageLiteral(resourceName: "science_tile")
        case .soc_culture:
            return #imageLiteral(resourceName: "society_culture_tile")
        case .sports_rec:
            return #imageLiteral(resourceName: "sports_tile")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film_tile")
        case .tech:
            return #imageLiteral(resourceName: "tech_tile")
        }
    }
}

class Topic: NSObject {
    
    var name: String
    var id: Int?
    var subtopics: [Topic]? // map topic to its subtopics, if there are any
    
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
