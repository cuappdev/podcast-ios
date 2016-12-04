//
//  REST.swift
//  Podcast
//
//  Created by Joseph Antonakakis on 9/12/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Router: URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    public func asURL() throws -> URL {
        let path: String = {
            switch self {
                case .endpoint:
                    return "/endpoint"
                case .userByFBToken:
                    return "/users/by_fb_token"
                case .searchEverything:
                    return "/search"
            }
        }()
        
        if let url = URL(string: Router.BackendHostURL + path) {
            return url
        } else {
            throw AFError.invalidURL(url: self)
        }
    }

    
    // Various endpoints
    case endpoint
    case searchEverything
    case userByFBToken
    
    // Backend URL
    static let BackendHostURL = "http://0.0.0.0:9000/v1"
    
    // Full URL based on path
    var URLString: String {
        let path: String = {
            switch self {
            case .endpoint:
                return "/endpoint"
            case .userByFBToken:
                return "/users/by_fb_token"
            case .searchEverything:
                return "/search"
            }
        }()
        return Router.BackendHostURL + path
    }
    
}

struct APIKey {
    static let Success = "success"
    static let Data = "data"
    static let Errors = "errors"
    static let Info = "info"
    static let Query = "query"
}

struct HeaderFields {
    static let FacebookToken = "FB_TOKEN"
}


// NOTE: GETs have .URL encoding, POSTs have .JSON encoding 
class REST {
    
    // Sample GET request
    static func someGetRequest(_ info: [String: Any], completion: @escaping (Error?) -> Void) {
        request(method: .get, params: [APIKey.Info : info], router: .endpoint, encoding: URLEncoding.queryString) { (data, error) in
            if error == nil {
                debugPrint("Data: \(data)")
            }
            completion(error)
        }
    }
    
    // Grab user (new or preexisting) via FB Token
    static func userByFBToken(token: String, completion: @escaping (_ userInfo: JSON, _ error: NSError?) -> Void) {
        request(method: .post, params: [:], router: .userByFBToken, encoding: JSONEncoding.default, headers: [HeaderFields.FacebookToken : token]) { (data, error) in
            debugPrint(data)
            if error == nil {}
            completion(data!, error as NSError?)
        }
    }
    
    // Search everything
    static func searchEverything(query: String, completion: @escaping (_ results : JSON, _ error: NSError?) -> Void) {
        request(method: .get, params: [APIKey.Query : query], router: .searchEverything, encoding: URLEncoding.queryString) { (results, error) in
            debugPrint(results)
            if error == nil {}
            completion(results!, error as NSError?)
        }
        
    }
    
    // Base Request Method
    fileprivate static func request(method: HTTPMethod, params: [String: Any], router: Router, encoding: ParameterEncoding, headers: [String: String] = [:], completion: @escaping (JSON?, Error?) -> Void) {
        Alamofire.request(router, method: method, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { response in
                debugPrint()
                debugPrint("**************************************** NEW REQUEST *************************************")
                debugPrint()
                debugPrint("URL: " + router.URLString)
                debugPrint()
                debugPrint("PARAMETERS: \(params)")
                if let error = response.result.error {
                    debugPrint()
                    debugPrint("ERROR: \(error.localizedDescription)")
                    debugPrint()
                    completion(nil, error)
                    return
                }
                
                let json = JSON(data: response.data!)
                debugPrint()
                debugPrint("RESPONSE:")
                debugPrint()
                debugPrint(json)
                
                if json[APIKey.Success].bool! {
                    completion(json[APIKey.Data], nil)
                } else {
                    guard let description = json[APIKey.Data][APIKey.Errors].array?.first?.string else { return }
                    completion(nil, MyError.backendError(description))
                }
        }
    }
    
    enum MyError: Error {
        case backendError(String)
        var localizedDescription: String {
            switch self {
            case .backendError:
                return "Uh oh something happened on the backend"
            }
        }
    }
}
