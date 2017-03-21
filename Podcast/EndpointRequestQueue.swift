
import UIKit

class EndpointRequestQueue: OperationQueue {
        
    override func addOperation(_ op: Operation) {
        
        guard let endpointRequest = op as? EndpointRequest, endpointRequest.requiresAuthenticatedUser else {
            super.addOperation(op)
            return
        }
        
        guard let session = System.currentSession else { return }
        
        // If the token is going to expire within the next hour, refresh it
        if session.expiresAt.timeIntervalSince1970 - 3600.0 < Date().timeIntervalSince1970 {
            refreshSessionToken(completion: {
                super.addOperation(endpointRequest)
            })
        } else {
            super.addOperation(endpointRequest)
        }
    }
    
    func refreshSessionToken(completion: (() -> ())?) {
        
        guard let updateToken = System.currentSession?.updateToken else { return }
        
        let updateSessionEndpointRequest = UpdateSessionEndpointRequest(updateToken: updateToken)
        
        updateSessionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            
            if let result = endpointRequest.processedResponseValue as? [String: Any],
            let _ = result["user"] as? User, let session = result["session"] as? Session {
                System.currentSession = session
            }
            
            completion?()
        }
        
        addOperation(updateSessionEndpointRequest)
    }
    
    func cancelAllEndpointRequestsOfType(type: AnyClass) {
        
        for operation in operations {
            if type(of: operation) == type {
                operation.cancel()
                print("Canceling: \((operation as! EndpointRequest).urlString())")
            }
        }
        
    }
    
}
