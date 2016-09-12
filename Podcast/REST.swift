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

enum Router: URLStringConvertible {
    
    // Various endpoints
    case Endpoint
    
    // Backend URL
    static let BackendHostURL = "http://0.0.0.0:8080/api/v1"
    
    // Full URL based on path
    var URLString: String {
        let path: String = {
            switch self {
            case .Endpoint:
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
    static func someGetRequest(info: [String: AnyObject], completion: (error: NSError?) -> Void) {
        request(.GET, params: [APIKey.Info : info], router: .Endpoint, encoding: .URL) { (data, error) in
            if error == nil {
                print("Data: \(data)")
            }
            completion(error: error)
        }
    }
    
    
    // Base Request Method
    private static func request(method: Alamofire.Method, params: [String: AnyObject], router: Router, encoding: ParameterEncoding, headers: [String: String] = [:], completion: (data: JSON?, error: NSError?) -> Void) {
        Alamofire.request(method, router, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { response in
                print()
                print("**************************************** NEW REQUEST *************************************")
                print()
                print("URL: " + router.URLString)
                print()
                print("PARAMETERS: \(params)")
                if let error = response.result.error {
                    print()
                    print("ERROR: (code: \(error.code)) \(error.localizedDescription)")
                    print()
                    completion(data: nil, error: error)
                    return
                }
                
                let json = JSON(data: response.data!)
                print()
                print("RESPONSE:")
                print()
                print(json)
                
                if json[APIKey.Success].bool! {
                    completion(data: json[APIKey.Data], error: nil)
                } else {
                    let error = json[APIKey.Data][APIKey.Errors].array?.first?.string
                    completion(data: nil, error: NSError(domain: "HubBackendDomain", code: -999999, userInfo: [kCFErrorLocalizedDescriptionKey : error ?? "Unknown Error"]))
                }
        }
    }
    
    
}