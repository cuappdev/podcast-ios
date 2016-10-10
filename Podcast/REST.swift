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
                case.endpoint:
                    return "/endpoint"
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
    
    // Backend URL
    static let BackendHostURL = "http://0.0.0.0:8080/api/v1"
    
    // Full URL based on path
    var URLString: String {
        let path: String = {
            switch self {
            case .endpoint:
                return "/endpoint"
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
}


// NOTE: GETs have .URL encoding, POSTs have .JSON encoding 
class REST {
    
    // Sample GET request
    static func someGetRequest(_ info: [String: Any], completion: @escaping (Error?) -> Void) {
        request(method: .get, params: [APIKey.Info : info], router: .endpoint, encoding: URLEncoding.queryString) { (data, error) in
            if error == nil {
                print("Data: \(data)")
            }
            completion(error)
        }
    }
    
    
    // Base Request Method
    fileprivate static func request(method: HTTPMethod, params: [String: Any], router: Router, encoding: ParameterEncoding, headers: [String: String] = [:], completion: @escaping (JSON?, Error?) -> Void) {
        Alamofire.request(router, method: method, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { response in
                print()
                print("**************************************** NEW REQUEST *************************************")
                print()
                print("URL: " + router.URLString)
                print()
                print("PARAMETERS: \(params)")
                if let error = response.result.error {
                    print()
                    print("ERROR: \(error.localizedDescription)")
                    print()
                    completion(nil, error)
                    return
                }
                
                let json = JSON(data: response.data!)
                print()
                print("RESPONSE:")
                print()
                print(json)
                
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
