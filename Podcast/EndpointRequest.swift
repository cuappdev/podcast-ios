
import UIKit
import Alamofire
import SwiftyJSON

class EndpointRequest: Operation {
    
    var baseURLString = "http://35.162.35.23"
    
    // Specific endpoint request path should always start with a /
    var path = "/"
    
    var httpMethod: HTTPMethod = .get
    var encoding: ParameterEncoding = JSONEncoding.default
    var queryParameters: [String:Any]?
    var bodyParameters: [String:Any]?
    var headers = [String:String]()
    
    var success: ((EndpointRequest) -> ())?
    var failure: ((EndpointRequest) -> ())?
    
    var responseJSON: JSON?
    
    // The result from processing the response JSON in processResponseJSON function
    var proccessedResponseValue: Any?
    
    override func main() {
        
        let endpointRequest = request(urlString(), method: httpMethod, parameters: parameters(), encoding: encoding, headers: headers)
        
        endpointRequest.validate(statusCode: 200 ..< 300).responseData { (response: DataResponse<Data>) in
            self.handleResponse(response: response)
        }
        
    }
    
    func handleResponse(response: DataResponse<Data>) {
        
        switch response.result {
            
            case .success(let data):
                
                responseJSON = JSON(data)
                proccessResponseJSON(responseJSON!)
                success?(self)
            
            case .failure(let error):
                
                if let endpoint = response.request {
                    print(endpoint)
                }
                
                print(error.localizedDescription)
                
                if let responseData = response.data {
                    responseJSON = JSON(responseData)
                }
            
                failure?(self)
        }
    }
    
    
    // Override in subclass to handle response from server
    func proccessResponseJSON(_ json: JSON) {
        
    }
    
    func urlString() -> String {
        return baseURLString + path
    }
    
    func parameters() -> [String:Any] {
        
        var params = [String:Any]()
        
        if let localBodyParameters = bodyParameters {
            encoding = JSONEncoding.default
            params = localBodyParameters
        } else if let localQueryParameters = queryParameters {
            encoding = URLEncoding.default
            return localQueryParameters
        }
        
        return params
    }
    
}
