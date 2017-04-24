
import UIKit
import SwiftyJSON
import GoogleSignIn
import GGLSignIn
import NVActivityIndicatorView

class GoogleLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var loginButton: GIDSignInButton!
    var loadingActivityIndicator: NVActivityIndicatorView!
    var podcastLogo: UIImageView!
    var podcastTitle: UILabel!
    var podcastDescription: UILabel!
    var gradient: CAGradientLayer!
    
    //Constants
    var podcastLogoWidth: CGFloat = 35
    var podcastLogoHeight: CGFloat = 35
    var paddingLogoTitle: CGFloat = 30
    var paddingTitleDescription: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let profileScope = "https://www.googleapis.com/auth/userinfo.profile"
        let emailScope = "https://www.googleapis.com/auth/userinfo.email"

        GIDSignIn.sharedInstance().scopes.append(contentsOf: [profileScope, emailScope])
        
        view.backgroundColor = .podcastTeal
        gradient = CAGradientLayer()
        let charcolGray = UIColor.charcolGray.withAlphaComponent(0.60).cgColor
        let white = UIColor.podcastWhite.withAlphaComponent(0.60).cgColor
        gradient.colors = [white,UIColor.podcastTeal.cgColor,charcolGray]
        gradient.startPoint = CGPoint(x: 0.60,y: 0)
        gradient.endPoint = CGPoint(x: 0.40,y: 1)
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, at: 0)
        
        loginButton = GIDSignInButton()
        loginButton.style = .wide
        loginButton.center.y = 3/4 * view.frame.height
        loginButton.center.x = view.center.x
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)
        
        podcastLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: podcastLogoWidth, height: podcastLogoHeight))
        podcastLogo.center.x = view.center.x
        podcastLogo.center.y = 1/4 * view.frame.height
        podcastLogo.image = #imageLiteral(resourceName: "podcast_logo")
        view.addSubview(podcastLogo)
        
        podcastTitle = UILabel(frame: CGRect.zero)
        let titleString = NSMutableAttributedString(string: "CAST", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight), NSKernAttributeName: 3.0])
        let podsString = NSMutableAttributedString(string: "PODS", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold), NSKernAttributeName: 0.9])
        titleString.append(podsString)
        podcastTitle.attributedText = titleString
        podcastTitle.textColor = .podcastWhite
        podcastTitle.sizeToFit()
        podcastTitle.center.x = podcastLogo.center.x
        podcastTitle.frame.origin.y = podcastLogo.frame.maxY + paddingLogoTitle
        view.addSubview(podcastTitle)
        
        podcastDescription = UILabel(frame: CGRect.zero)
        podcastDescription.text = "Listen, learn, connect."
        podcastDescription.font = UIFont.systemFont(ofSize: 16)
        podcastDescription.textColor = .podcastWhite
        podcastDescription.sizeToFit()
        podcastDescription.center.x = podcastTitle.center.x
        podcastDescription.frame.origin.y = podcastTitle.frame.maxY + paddingTitleDescription
        view.addSubview(podcastDescription)
        
        loadingActivityIndicator = createLoadingAnimationView()
        loadingActivityIndicator.center = view.center
        view.addSubview(loadingActivityIndicator)
    }
    
    func loginButtonPressed() {
        loginButton.isHidden = true
        loadingActivityIndicator.startAnimating()
    }
    
    func signInSilently() {
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            print("\(error.localizedDescription)")
            loadingActivityIndicator.stopAnimating()
            self.loginButton.isHidden = false
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
            
            self.loadingActivityIndicator.stopAnimating()
            self.loginButton.isHidden = false
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








