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
    // this is terrible. send help
    case arts = "Arts"
    case food = "Food"
    case fashion_beauty = "Fashion & Beauty"
    case design = "Design"
    case literature = "Literature"
    case visual_arts = "Visual Arts"
    case performing_arts = "Performing Arts"

    case business = "Business"
    case careers = "Careers"
    case shopping = "Shopping"
    case investing = "Investing"
    case business_news = "Business News"
    case management_marketing = "Management & Marketing"

    case comedy = "Comedy"

    case education = "Education"
    case training = "Training"
    case language_courses = "Language Courses"
    case ed_tech = "Educational Technology"
    case higher_ed = "Higher Education"
    case k12 = "K-12"

    case games_hobbies = "Games & Hobbies"
    case auto = "Automotive"
    case aviation = "Aviation"
    case other_games = "Other Games"
    case hobbies = "Hobbies"
    case video_games = "Video Games"

    case gov_org = "Government & Organizations"
    case national = "National"
    case nonprofit = "Non-Profit"
    case regional = "Regional"
    case local = "Local"

    case health = "Health"
    case sexuality = "Sexuality"
    case self_help = "Self-Help"
    case alt_health = "Alternative Health"
    case fitness = "Fitness & Nutrition"

    case kids_family = "Kids & Family"

    case music = "Music"

    case news_politics = "News & Politics"

    case religion_spirituality = "Religion & Spirituality"
    case buddhism = "Buddhism"
    case christianity = "Christianity"
    case spirituality = "Spirituality"
    case judaism = "Judaism"
    case islam = "Islam"
    case other = "Other"
    case hinduism = "Hinduism"

    case sci_med = "Science & Medicine"
    case medicine = "Medicine"
    case social_sciences = "Social Sciences"
    case natural_sciences = "Natural Sciences"

    case soc_culture = "Society & Culture"
    case places_travel = "Places & Travel"
    case philosophy = "Philosophy"
    case personal_journals = "Personal Journals"
    case history = "History"

    case sports_rec = "Sports & Recreation"
    case professional = "Professional"
    case amateur = "Amateur"
    case college_hs = "College & High School"
    case outdoor = "Outdoor"

    case tv_film = "TV & Film"

    case tech = "Technology"
    case gadgets = "Gadgets"
    case software = "Software How-To"
    case podcasting = "Podcasting"
    case tech_news = "Tech News"

    var image: UIImage {
        switch self {
        case .arts, .food, .fashion_beauty, .design, .literature, .performing_arts, .visual_arts:
            return #imageLiteral(resourceName: "arts_icon")
        case .business, .business_news, .investing, .shopping, .careers, .management_marketing:
            return #imageLiteral(resourceName: "business_icon")
        case .comedy:
            return #imageLiteral(resourceName: "comedy_icon")
        case .education, .training, .language_courses, .ed_tech, .higher_ed, .k12:
            return #imageLiteral(resourceName: "education_icon")
        case .games_hobbies, .auto, .aviation, .other_games, .hobbies, .video_games:
            return #imageLiteral(resourceName: "games_hobbies_icon")
        case .gov_org, .national, .nonprofit, .regional, .local:
            return #imageLiteral(resourceName: "government_icon")
        case .health, .sexuality, .self_help, .alt_health, .fitness:
            return #imageLiteral(resourceName: "health_icon")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_icon")
        case .music:
            return #imageLiteral(resourceName: "music_icon")
        case .news_politics:
            return #imageLiteral(resourceName: "news_politics_icon")
        case .religion_spirituality, .buddhism, .christianity, .islam, .judaism, .hinduism, .spirituality, .other:
            return #imageLiteral(resourceName: "religion_icon")
        case .sci_med, .medicine, .social_sciences, .natural_sciences:
            return #imageLiteral(resourceName: "science_icon")
        case .soc_culture, .places_travel, .philosophy, .personal_journals, .history:
            return #imageLiteral(resourceName: "society_culture_icon")
        case .sports_rec, .professional, .amateur, .college_hs, .outdoor:
            return #imageLiteral(resourceName: "sports_icon")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film_icon")
        case .tech, .gadgets, .software, .podcasting, .tech_news:
            return #imageLiteral(resourceName: "tech_icon")
        }
    }

    var headerImage: UIImage {
        switch self {
        case .arts, .food, .fashion_beauty, .design, .literature, .performing_arts, .visual_arts:
            return #imageLiteral(resourceName: "art_header")
        case .business, .business_news, .investing, .shopping, .careers, .management_marketing:
            return #imageLiteral(resourceName: "business_header")
        case .comedy:
            return #imageLiteral(resourceName: "comedy_header")
        case .education, .training, .language_courses, .ed_tech, .higher_ed, .k12:
            return #imageLiteral(resourceName: "education_header")
        case .games_hobbies, .auto, .aviation, .other_games, .hobbies, .video_games:
            return #imageLiteral(resourceName: "games_header")
        case .gov_org, .national, .nonprofit, .regional, .local:
            return #imageLiteral(resourceName: "government_header")
        case .health, .sexuality, .self_help, .alt_health, .fitness:
            return #imageLiteral(resourceName: "health_header")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_header")
        case .music:
            return #imageLiteral(resourceName: "music_header")
        case .news_politics:
            return #imageLiteral(resourceName: "news_politics_header")
        case .religion_spirituality, .buddhism, .christianity, .islam, .judaism, .hinduism, .spirituality, .other:
            return #imageLiteral(resourceName: "religion_header")
        case .sci_med, .medicine, .social_sciences, .natural_sciences:
            return #imageLiteral(resourceName: "science_header")
        case .soc_culture, .places_travel, .philosophy, .personal_journals, .history:
            return #imageLiteral(resourceName: "society_culture_header")
        case .sports_rec, .professional, .amateur, .college_hs, .outdoor:
            return #imageLiteral(resourceName: "sports_header")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film_header")
        case .tech, .gadgets, .software, .podcasting, .tech_news:
            return #imageLiteral(resourceName: "tech_header")
        }
    }

    var tileImage: UIImage {
        switch self {
        case .arts, .food, .fashion_beauty, .design, .literature, .performing_arts, .visual_arts:
            return #imageLiteral(resourceName: "arts_tile")
        case .business, .business_news, .investing, .shopping, .careers, .management_marketing:
            return #imageLiteral(resourceName: "business_tile")
        case .comedy:
            return #imageLiteral(resourceName: "comedy_tile")
        case .education, .training, .language_courses, .ed_tech, .higher_ed, .k12:
            return #imageLiteral(resourceName: "education_tile")
        case .games_hobbies, .auto, .aviation, .other_games, .hobbies, .video_games:
            return #imageLiteral(resourceName: "games_tile")
        case .gov_org, .national, .nonprofit, .regional, .local:
            return #imageLiteral(resourceName: "government_tile")
        case .health, .sexuality, .self_help, .alt_health, .fitness:
            return #imageLiteral(resourceName: "health_tile")
        case .kids_family:
            return #imageLiteral(resourceName: "kids_tile")
        case .music:
            return #imageLiteral(resourceName: "music_tile")
        case .news_politics:
            return #imageLiteral(resourceName: "news_tile")
        case .religion_spirituality, .buddhism, .christianity, .islam, .judaism, .hinduism, .spirituality, .other:
            return #imageLiteral(resourceName: "religion_tile")
        case .sci_med, .medicine, .social_sciences, .natural_sciences:
            return #imageLiteral(resourceName: "science_tile")
        case .soc_culture, .places_travel, .philosophy, .personal_journals, .history:
            return #imageLiteral(resourceName: "society_culture_tile")
        case .sports_rec, .professional, .amateur, .college_hs, .outdoor:
            return #imageLiteral(resourceName: "sports_tile")
        case .tv_film:
            return #imageLiteral(resourceName: "tv_film_tile")
        case .tech, .gadgets, .software, .podcasting, .tech_news:
            return #imageLiteral(resourceName: "tech_tile")
        }
    }

    var id: Int {
        switch self {
        case .arts:
            return 1301
        case .food:
            return 1306
        case .fashion_beauty:
            return 1459
        case .design:
            return 1402
        case .literature:
            return 1401
        case .visual_arts:
            return 1406
        case .performing_arts:
            return 1405
        case .business:
            return 1321
        case .careers:
            return 1410
        case .shopping:
            return 1472
        case .investing:
            return 1412
        case .business_news:
            return 1471
        case .management_marketing:
            return 1413
        case .comedy:
            return 1303
        case .education:
            return 1304
        case .training:
            return 1470
        case .language_courses:
            return 1469
        case .ed_tech:
            return 1468
        case .higher_ed:
            return 1416
        case .k12:
            return 1415
        case .games_hobbies:
            return 1323
        case .auto:
            return 1454
        case .aviation:
            return 1455
        case .other_games:
            return 1461
        case .hobbies:
            return 1460
        case .video_games:
            return 1404
        case .gov_org:
            return 1325
        case .national:
            return 1473
        case .nonprofit:
            return 1476
        case .regional:
            return 1474
        case .local:
            return 1475
        case .health:
            return 1307
        case .sexuality:
            return 1421
        case .self_help:
            return 1420
        case .alt_health:
            return 1481
        case .fitness:
            return 1417
        case .kids_family:
            return 1305
        case .music:
            return 1310
        case .news_politics:
            return 1311
        case .religion_spirituality:
            return 1314
        case .buddhism:
            return 1438
        case .christianity:
            return 1439
        case .spirituality:
            return 1444
        case .judaism:
            return 1441
        case .islam:
            return 1440
        case .other:
            return 1464
        case .hinduism:
            return 1463
        case .sci_med:
            return 1315
        case .medicine:
            return 1478
        case .social_sciences:
            return 1479
        case .natural_sciences:
            return 1477
        case .soc_culture:
            return 1324
        case .places_travel:
            return 1320
        case .philosophy:
            return 1443
        case .personal_journals:
            return 1302
        case .history:
            return 1462
        case .sports_rec:
            return 1316
        case .professional:
            return 1465
        case .amateur:
            return 1467
        case .college_hs:
            return 1466
        case .outdoor:
            return 1456
        case .tv_film:
            return 1309
        case .tech:
            return 1318
        case .gadgets:
            return 1446
        case .software:
            return 1480
        case .podcasting:
            return 1450
        case .tech_news:
            return 1448
        }
    }

    func getParentTopic() -> TopicType? {
        switch self {
        case .food, .fashion_beauty, .design, .literature, .performing_arts, .visual_arts:
            return .arts
        case .business_news, .investing, .shopping, .careers, .management_marketing:
            return .business
        case .training, .language_courses, .ed_tech, .higher_ed, .k12:
            return .education
        case .auto, .aviation, .other_games, .hobbies, .video_games:
            return .games_hobbies
        case .national, .nonprofit, .regional, .local:
            return .gov_org
        case .sexuality, .self_help, .alt_health, .fitness:
            return .health
        case .buddhism, .christianity, .islam, .judaism, .hinduism, .spirituality, .other:
            return .religion_spirituality
        case .medicine, .social_sciences, .natural_sciences:
            return .sci_med
        case .places_travel, .philosophy, .personal_journals, .history:
            return .soc_culture
        case .professional, .amateur, .college_hs, .outdoor:
            return .sports_rec
        case .gadgets, .software, .podcasting, .tech_news:
            return .tech
        default:
            return nil
        }
    }

    func getSubtopics() -> [TopicType] {
        switch self {
        case .arts:
            return [.food, .fashion_beauty, .design, .literature, .performing_arts, .visual_arts]
        case .business:
            return [.business_news, .investing, .shopping, .careers, .management_marketing]
        case .education:
            return [.training, .language_courses, .ed_tech, .higher_ed, .k12]
        case .games_hobbies:
            return [.auto, .aviation, .other_games, .hobbies, .video_games]
        case .gov_org:
            return [.national, .nonprofit, .regional, .local]
        case .health:
            return [.sexuality, .self_help, .alt_health, .fitness]
        case .religion_spirituality:
            return [.buddhism, .christianity, .islam, .judaism, .hinduism, .spirituality, .other]
        case .sci_med:
            return [.medicine, .social_sciences, .natural_sciences]
        case .soc_culture:
            return [.places_travel, .philosophy, .personal_journals, .history]
        case .sports_rec:
            return [.professional, .amateur, .college_hs, .outdoor]
        case .tech:
            return [.gadgets, .software, .podcasting, .tech_news]
        default:
            return []
        }
    }

    func toTopic() -> Topic {
        return Topic(name: rawValue, id: id, subtopics: getSubtopics().map({ $0.toTopic() }))
    }

}

class Topic: NSObject, NSCoding {
    
    var name: String
    var id: Int?
    var subtopics: [Topic]? // map topic to its subtopics, if there are any
    var topicType: TopicType?

    private static let name_key = "tag_name"
    
    init(name: String, id: Int? = nil, subtopics: [Topic]? = nil) {
        self.name = name
        self.id = id
        self.subtopics = subtopics
        self.topicType = TopicType(rawValue: name)
        super.init()
    }

    convenience init(json: JSON) {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let subtopics = json["subtopics"].map{ topicJSON in Topic(json: topicJSON.1) }
        self.init(name: name, id: id, subtopics: subtopics)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Topic.name_key)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(name: "")
        if let obj = aDecoder.decodeObject(forKey: Topic.name_key) as? String {
            self.name = obj
            self.topicType = TopicType(rawValue: obj)
        }
    }

}
