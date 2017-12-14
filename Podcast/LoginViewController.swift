
import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import FacebookLogin
import FacebookCore

enum SignInType {
    case Facebook
    case Google
}

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var googleLoginButton: UIButton!
    var facebookLoginButton: UIButton!
    var loadingActivityIndicator: NVActivityIndicatorView!
    var loginBackgroundGradientView: LoginBackgroundGradientView!
    var podcastLogoView: LoginPodcastLogoView!
    var loginManager: LoginManager!
    
    
    //Constants
    var signInButtonTopPadding: CGFloat = 72
    var signInButtonWidth: CGFloat = 270
    var signInButtonHeight: CGFloat = 42
    var signInButtonSmallPadding: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        GIDSignIn.sharedInstance().clientID = "724742275706-h8qs46h90squts3dco76p0q6lja2c7nh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let profileScope = "https://www.googleapis.com/auth/userinfo.profile"
        let emailScope = "https://www.googleapis.com/auth/userinfo.email"
        
        GIDSignIn.sharedInstance().scopes.append(contentsOf: [profileScope, emailScope])
        loginManager = LoginManager()

        loginBackgroundGradientView = LoginBackgroundGradientView(frame: view.frame)
        view.addSubview(loginBackgroundGradientView)

        podcastLogoView = LoginPodcastLogoView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4))
        view.addSubview(podcastLogoView)

        podcastLogoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.top.equalTo(0).inset(view.frame.width * 0.25)
        }

        facebookLoginButton = UIButton()
        facebookLoginButton.setBackgroundImage(#imageLiteral(resourceName: "signinFb"), for: .normal)
        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonPress), for: .touchUpInside)
        view.addSubview(facebookLoginButton)

        facebookLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(podcastLogoView.snp.bottom).offset(signInButtonTopPadding)
            make.width.equalTo(signInButtonWidth)
            make.height.equalTo(signInButtonHeight)
        }

        googleLoginButton = UIButton()
        googleLoginButton.setBackgroundImage(#imageLiteral(resourceName: "signinGoogle"), for: .normal)
        googleLoginButton.addTarget(self, action: #selector(googleLoginButtonPress), for: .touchUpInside)
        view.addSubview(googleLoginButton)

        googleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(facebookLoginButton.snp.bottom).offset(signInButtonSmallPadding)
            make.width.equalTo(signInButtonWidth)
            make.height.equalTo(signInButtonHeight)
        }

        loadingActivityIndicator = LoadingAnimatorUtilities.createLoadingAnimator()
        loadingActivityIndicator.center = view.center
        loadingActivityIndicator.color = .offWhite
        loadingActivityIndicator.startAnimating()
        view.addSubview(loadingActivityIndicator)
        
        hideLoginButtons(isHidden: true)

        if let accessToken = AccessToken.current {
            // signed in with facebook
            authenticateUser(signInType: .Facebook, accessToken: accessToken.authenticationToken)
        } else {
            // try signing in with Google
            signInSilently()
        }
    }

    @objc func googleLoginButtonPress() {
        hideLoginButtons(isHidden: true)
        loadingActivityIndicator.startAnimating()
        GIDSignIn.sharedInstance().signIn()
    }

    @objc func facebookLoginButtonPress() {
        hideLoginButtons(isHidden: true)
        loadingActivityIndicator.startAnimating()
        signInWithFacebook()
    }


    //MARK
    //MARK - Facebook Sign in
    //MARK

    func signInWithFacebook() {
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.authenticateUser(signInType: .Facebook, accessToken: accessToken.authenticationToken)
            }
        }
    }

    //MARK
    //MARK - Google Sign in
    //MARK

    // Google sign in silently
    func signInSilently() {
        GIDSignIn.sharedInstance().signInSilently()
    }

    // Google sign in functionality
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("\(error.localizedDescription)")
            hideLoginButtons(isHidden: false)
            loadingActivityIndicator.stopAnimating()
            return
        }
        
        guard let accessToken = user.authentication.accessToken else { return } // Safe to send to the server
        
        authenticateUser(signInType: .Google, accessToken: accessToken)
    }

    func logout() {
        GIDSignIn.sharedInstance().signOut()
        loginManager.logOut()
    }

    // Google sign in functionality
    func handleSignIn(url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    func hideLoginButtons(isHidden: Bool) {
        facebookLoginButton.isHidden = isHidden
        googleLoginButton.isHidden = isHidden
    }

    func authenticateUser(signInType: SignInType, accessToken: String) {
        let authenticateUserEndpointRequest: EndpointRequest

        if signInType == .Facebook {
            authenticateUserEndpointRequest = AuthenticateFacebookUserEndpointRequest(accessToken: accessToken)
        } else {
            authenticateUserEndpointRequest = AuthenticateGoogleUserEndpointRequest(accessToken: accessToken)
        }


        authenticateUserEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            guard let result = endpointRequest.processedResponseValue as? [String: Any],
                let user = result["user"] as? User, let session = result["session"] as? Session, let isNewUser = result["is_new_user"] as? Bool else {
                    print("error authenticating")
                    return
            }

            System.currentUser = user
            System.currentSession = session

            self.loadingActivityIndicator.stopAnimating()
            self.hideLoginButtons(isHidden: false)

            if isNewUser {
                let loginUsernameVC = LoginUsernameViewController()
                loginUsernameVC.user = user
                self.navigationController?.pushViewController(loginUsernameVC, animated: false)
            } else {
                appDelegate.didFinishAuthenticatingUser()
            }
        }

        authenticateUserEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            self.loadingActivityIndicator.stopAnimating()
            self.hideLoginButtons(isHidden: false)
        }

        System.endpointRequestQueue.addOperation(authenticateUserEndpointRequest)
    }
}








