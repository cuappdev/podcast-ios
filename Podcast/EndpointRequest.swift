
import UIKit
import Alamofire
import SwiftyJSON

class EndpointRequest: Operation {
    
    var baseURLString: String = Keys.apiURL.value
    
    // Specific endpoint request path should always start with a /
    var path = "/"
    
    var httpMethod: HTTPMethod = .get
    var encoding: ParameterEncoding = URLEncoding.default
    var queryParameters: [String:Any]?
    var bodyParameters: [String:Any]?
    var headers = [String:String]()
    var requiresAuthenticatedUser: Bool = true
    
    var success: ((EndpointRequest) -> ())?
    var failure: ((EndpointRequest) -> ())?
    
    var responseJSON: JSON?
    
    // The result from processing the response JSON in processResponseJSON function
    var processedResponseValue: Any?
    
    // Used to hold endpoint request in operation queue until we explicitly say it's finished
    private var _finished : Bool = false
    override var isFinished : Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        
        if isCancelled {
            isFinished = true
            return
        }

        var endpointRequest: DataRequest? = nil


        // both query and body params
        // this isn't convention to do both but we do it for facebook requests
        if let bodyParams = bodyParameters, let queryParams = queryParameters {
            let encoding = URLEncoding(destination: .queryString)
            if let url = URL(string: urlString()), let encodedURL = try? encoding.encode(URLRequest(url: url), with: queryParams) {
                guard let actualURL = try? encoding.encode(encodedURL, with: queryParameters), let urlToSend = actualURL.url else { return }
                endpointRequest = request(urlToSend, method: httpMethod, parameters: bodyParams, encoding: JSONEncoding.default, headers: authorizedHeaders())
            }
        } else { // query OR body params
            endpointRequest = request(urlString(), method: httpMethod, parameters: parameters(), encoding: encoding, headers: authorizedHeaders())
        }

        endpointRequest?.validate(statusCode: 200 ..< 300).responseData { (response: DataResponse<Data>) in
            if self.isCancelled {
                self.isFinished = true
                return
            }
            self.handleResponse(response: response)
            self.isFinished = true
        }
    }
    
    func handleResponse(response: DataResponse<Data>) {
        switch response.result {
            
            case .success(let data):
            if let responseJSON = try? JSON(data: data) {
                if responseJSON["success"].boolValue {
                    processResponseJSON(responseJSON)
                    DispatchQueue.main.async {
                        self.success?(self)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.failure?(self)
            }
            
            case .failure(let error):
                print(error.localizedDescription)
                if let endpoint = response.request {
                    print(endpoint)
                }

                if let responseData = response.data {
                    responseJSON = JSON(responseData)
                }
                
                DispatchQueue.main.async {
                    self.failure?(self)
                }
        }
    }
    
    
    // Override in subclass to handle response from server
    func processResponseJSON(_ json: JSON) {
        
    }
    
    func urlString() -> String {
        return baseURLString + path
    }
    
    func parameters() -> [String:Any] {
        
        var params = [String:Any]()
        
        if let localBodyParameters = bodyParameters {
            encoding = JSONEncoding.default
            return localBodyParameters
        }

        if let localQueryParameters = queryParameters {
            encoding = URLEncoding(destination: .queryString)
            return localQueryParameters
        }
        
        return params
    }
    
    func authorizedHeaders() -> [String: String] {
        
        if requiresAuthenticatedUser {
            guard let sessionToken = System.currentSession?.sessionToken else { return headers }
            headers["Authorization"] = "Bearer \(sessionToken)"
            return headers
        }
        
        return headers
    }

    /* To encode booleans for query parameters b/c alamofire encodes boolean true -> 1, boolean false -> 0 */
    func encodeBoolean(_ parameter: Bool) -> String {
        return parameter ? "true" : "false"
    }
}
