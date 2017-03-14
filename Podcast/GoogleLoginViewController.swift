
import UIKit
import SwiftyJSON
import GoogleSignIn
import GGLSignIn

class GoogleLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var loginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .podcastWhite
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let profileScope = "https://www.googleapis.com/auth/userinfo.profile"
        let emailScope = "https://www.googleapis.com/auth/userinfo.email"

        GIDSignIn.sharedInstance().scopes.append(contentsOf: [profileScope, emailScope])
        
        loginButton = GIDSignInButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    func signInSilently() {
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            print("\(error.localizedDescription)")
            return
        }
        
        guard let idToken = user.authentication.idToken else { return } // Safe to send to the server

        let authenticateGoogleUserEndpointRequest = AuthenticateGoogleUserEndpointRequest(idToken: idToken)
        
        authenticateGoogleUserEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            guard let result = endpointRequest.processedResponseValue as? [String: Any],
            let user = result["user"] as? User, let session = result["session"] as? Session else {
                print("error authenticating")
                return
            }
            
            System.currentUser = user
            System.currentSession = session
            
            appDelegate.didFinishAuthenticatingUser()
        }
        
        System.endpointRequestQueue.addOperation(authenticateGoogleUserEndpointRequest)
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func handleSignIn(url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}








