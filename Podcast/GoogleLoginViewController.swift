
import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class GoogleLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var loginButton: GIDSignInButton!
    var loadingActivityIndicator: NVActivityIndicatorView!
    var loginBackgroundGradientView: LoginBackgroundGradientView!
    var podcastLogoView: LoginPodcastLogoView!
    
    
    //Constants
    var loginButtonViewY: CGFloat = 362
    var podcastLogoViewY: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        GIDSignIn.sharedInstance().clientID = "724742275706-h8qs46h90squts3dco76p0q6lja2c7nh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let profileScope = "https://www.googleapis.com/auth/userinfo.profile"
        let emailScope = "https://www.googleapis.com/auth/userinfo.email"

        GIDSignIn.sharedInstance().scopes.append(contentsOf: [profileScope, emailScope])
        
        loginBackgroundGradientView = LoginBackgroundGradientView(frame: view.frame)
        view.addSubview(loginBackgroundGradientView)
        
        loginButton = GIDSignInButton()
        loginButton.style = .wide
        loginButton.frame.origin.y = loginButtonViewY
        loginButton.center.x = view.center.x
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)
        
        podcastLogoView = LoginPodcastLogoView(frame: CGRect(x: 0, y: podcastLogoViewY, width: view.frame.width, height: view.frame.height / 4))
        podcastLogoView.center.x = view.center.x
        view.addSubview(podcastLogoView)
        
        loadingActivityIndicator = LoadingAnimatorUtilities.createLoadingAnimator()
        loadingActivityIndicator.center = view.center
        loadingActivityIndicator.color = .offWhite
        loadingActivityIndicator.startAnimating()
        view.addSubview(loadingActivityIndicator)
        
        loginButton.isHidden = true
        
        signInSilently()
    }
    
    @objc func loginButtonPressed() {
        loginButton.isHidden = true
        loadingActivityIndicator.startAnimating()
    }
    
    func signInSilently() {
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            print("\(error.localizedDescription)")
            loginButton.isHidden = false
            loadingActivityIndicator.stopAnimating()
            self.loginButton.isHidden = false
            return
        }
        
        guard let accessToken = user.authentication.accessToken else { return } // Safe to send to the server
        
        let authenticateGoogleUserEndpointRequest = AuthenticateGoogleUserEndpointRequest(accessToken: accessToken)
        
        authenticateGoogleUserEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            guard let result = endpointRequest.processedResponseValue as? [String: Any],
            let user = result["user"] as? User, let session = result["session"] as? Session, let isNewUser = result["is_new_user"] as? Bool else {
                print("error authenticating")
                return
            }
            
            System.currentUser = user
            System.currentSession = session
            
            self.loadingActivityIndicator.stopAnimating()
            self.loginButton.isHidden = false
            
            if isNewUser {
                let loginUsernameVC = LoginUsernameViewController()
                loginUsernameVC.user = user
                self.navigationController?.pushViewController(loginUsernameVC, animated: false)
            } else {
                appDelegate.didFinishAuthenticatingUser()
            }
        }
        
        authenticateGoogleUserEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            self.loadingActivityIndicator.stopAnimating()
            self.loginButton.isHidden = false
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








