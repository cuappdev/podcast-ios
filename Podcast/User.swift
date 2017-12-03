//
//  User.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit 
import SwiftyJSON

class User: NSObject {
    
    var id: String
    var firstName: String
    var lastName: String
    var isFollowing: Bool
    var numberOfFollowers: Int
    var username: String
    var imageURL: URL?
    var numberOfFollowing: Int
    
    //init with all atributes
    init(id: String, firstName: String, lastName: String, username: String, imageURL: URL?, numberOfFollowers: Int, numberOfFollowing: Int, isFollowing: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        self.numberOfFollowing = numberOfFollowing
        super.init()
    }
    
    convenience init(json: JSON) {
        let id = json["id"].stringValue
        let firstName = json["first_name"].stringValue
        let lastName = json["last_name"].stringValue
        let username = json["username"].stringValue
        let numberOfFollowers = json["followers_count"].intValue
        let numberOfFollowing = json["followings_count"].intValue
        let isFollowing = json["is_following"].boolValue
        let imageURL = URL(string: json["image_url"].stringValue)
        
        self.init(id: id, firstName: firstName, lastName: lastName, username: username, imageURL: imageURL, numberOfFollowers: numberOfFollowers, numberOfFollowing: numberOfFollowing, isFollowing: isFollowing)
    }
    
    func update(json: JSON) {
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        username = json["username"].stringValue
        numberOfFollowers = json["followers_count"].intValue
        numberOfFollowing = json["followings_count"].intValue
        isFollowing = json["is_following"].boolValue
        imageURL = URL(string: json["image_url"].stringValue)
    }
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func followChange(completion: ((Bool, Int) -> ())? = nil) {
        guard let currentUser = System.currentUser, currentUser.id != self.id else { return }
        isFollowing ? unfollow(success: completion, failure: completion) : follow(success: completion, failure: completion)
    }
    
    func follow(success: ((Bool, Int) -> ())? = nil, failure: ((Bool, Int) -> ())? = nil) {
        guard let currentUser = System.currentUser, currentUser.id != self.id else { return }
        let endpointRequest = FollowUserEndpointRequest(userID: id)
        endpointRequest.success = { _ in
            self.isFollowing = true
            currentUser.numberOfFollowing += 1
            self.numberOfFollowers += 1
            success?(self.isFollowing, self.numberOfFollowers)
        }
        endpointRequest.failure = { _ in
            self.isFollowing = false
            failure?(self.isFollowing, self.numberOfFollowers)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func unfollow(success: ((Bool, Int) -> ())? = nil, failure: ((Bool, Int) -> ())? = nil) {
        guard let currentUser = System.currentUser, currentUser.id != self.id else { return }
        let endpointRequest = UnfollowUserEndpointRequest(userID: id)
        endpointRequest.success = { _ in
            self.isFollowing = false
            currentUser.numberOfFollowing -= 1
            self.numberOfFollowers -= 1
            success?(self.isFollowing, self.numberOfFollowers)
        }
        endpointRequest.failure = { _ in
            self.isFollowing = true
            failure?(self.isFollowing, self.numberOfFollowers)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    func changeUsername(username: String, success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let changeUsernameEndpointRequest = ChangeUsernameEndpointRequest(username: username)
        changeUsernameEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            self.username = username
            success?()
        }

        changeUsernameEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            failure?()
        }
        System.endpointRequestQueue.addOperation(changeUsernameEndpointRequest)
    }
}
