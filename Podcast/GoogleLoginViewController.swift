
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
        
        // DELETE when endpoint is live
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.didFinishAuthenticatingUser()
        return
        
//        let userId = user.userID                  // For client-side use only!
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
        
        guard let idToken = user.authentication.idToken else { return } // Safe to send to the server

        let authenticateGoogleUserEndpointRequest = AuthenticateGoogleUserEndpointRequest(idToken: idToken)
        
        authenticateGoogleUserEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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








