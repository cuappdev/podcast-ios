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
    var isFacebookUser: Bool
    var facebookId: String? // if isFacebookUser then facebookId != nil, otherwise nil
    var isGoogleUser: Bool
    var hasRecasted: Bool? { // only for current user
        get {
            if self == System.currentUser {
                return UserDefaults.standard.bool(forKey: "hasRecasted")
            }
            return nil
        }

        set(newValue) {
            if self == System.currentUser {
                UserDefaults.standard.set(newValue, forKey: "hasRecasted")
            }
        }
    }
    
    //init with all atributes
    init(id: String, firstName: String, lastName: String, username: String, imageURL: URL?, numberOfFollowers: Int, numberOfFollowing: Int, isFollowing: Bool, isFacebookUser: Bool, facebookId: String?, isGoogleUser: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        self.numberOfFollowing = numberOfFollowing
        self.isGoogleUser = isGoogleUser
        self.isFacebookUser = isFacebookUser
        self.facebookId = facebookId
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

        let isFacebookUser = json["facebook_id"].stringValue != "null" && json["facebook_id"].stringValue != ""
        let facebookId = isFacebookUser ? json["facebook_id"].stringValue : nil
        let isGoogleUser = json["google_id"].stringValue != "null" && json["google_id"].stringValue != ""

        self.init(id: id, firstName: firstName, lastName: lastName, username: username, imageURL: imageURL, numberOfFollowers: numberOfFollowers, numberOfFollowing: numberOfFollowing, isFollowing: isFollowing, isFacebookUser: isFacebookUser, facebookId: facebookId, isGoogleUser: isGoogleUser)
    }
    
    func update(json: JSON) {
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        username = json["username"].stringValue
        numberOfFollowers = json["followers_count"].intValue
        numberOfFollowing = json["followings_count"].intValue
        isFollowing = json["is_following"].boolValue
        imageURL = URL(string: json["image_url"].stringValue)
        isFacebookUser = json["facebook_id"].stringValue != "null" && json["facebook_id"].stringValue != ""
        facebookId = isFacebookUser ? json["facebook_id"].stringValue : nil
        isGoogleUser = json["google_id"].stringValue != "null" && json["google_id"].stringValue != ""
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
        let endpointRequest = ModifyFollowEndpointRequest(userID: id, action: .create)
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
        let endpointRequest = ModifyFollowEndpointRequest(userID: id, action: .delete)
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
        if username.contains(" ") || username == "" { failure?() }
        else {
            let changeUsernameEndpointRequest = ChangeUsernameEndpointRequest(username: username)
            changeUsernameEndpointRequest.success = { _ in
                self.username = username
                success?()
            }

            changeUsernameEndpointRequest.failure = { _ in
                failure?()
            }
            System.endpointRequestQueue.addOperation(changeUsernameEndpointRequest)
        }
    }

    // dismisses this user for the current users facebook friend suggestions
    func dismissAsSuggestedFacebookFriend(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        guard let currentUser = System.currentUser, let accessToken = Authentication.sharedInstance.facebookAccessToken, let id = facebookId, currentUser.id != self.id else { return }
        let endpointRequest = DismissFacebookFriendEndpointRequest(facebookAccessToken: accessToken, facebookId: id)
        endpointRequest.success = { _ in
            success?()
        }

        endpointRequest.failure = { _ in
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
