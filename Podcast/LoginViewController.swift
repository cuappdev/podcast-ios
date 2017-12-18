
import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    var googleLoginButton: UIButton!
    var facebookLoginButton: UIButton!
    var loadingActivityIndicator: NVActivityIndicatorView!
    var loginBackgroundGradientView: LoginBackgroundGradientView!
    var podcastLogoView: LoginPodcastLogoView!
    
    
    //Constants
    var signInButtonTopPadding: CGFloat = 72
    var signInButtonWidth: CGFloat = 270
    var signInButtonHeight: CGFloat = 42
    var signInButtonSmallPadding: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

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

        // if we have a valid access token for Facebook or Google then sign in silently
        if let accessToken = Authentication.sharedInstance.facebookAccessToken {
            // try signing in with Facebook
            Authentication.sharedInstance.authenticateUser(signInType: .Facebook, accessToken: accessToken, success: self.signInSuccess, failure: self.signInFailure)
        } else {
            Authentication.sharedInstance.signInSilentlyWithGoogle() // Google delegate method will be called when this completes
        }
    }

    @objc func googleLoginButtonPress() {
        hideLoginButtons(isHidden: true)
        loadingActivityIndicator.startAnimating()
        Authentication.sharedInstance.signInWithGoogle()
    }

    @objc func facebookLoginButtonPress() {
        hideLoginButtons(isHidden: true)
        loadingActivityIndicator.startAnimating()
        Authentication.sharedInstance.signInWithFacebook(viewController: self, success: {
            guard let accessToken = AccessToken.current?.authenticationToken else { return } // Safe to send to the server
            Authentication.sharedInstance.authenticateUser(signInType: .Facebook, accessToken: accessToken, success: self.signInSuccess, failure: self.signInFailure)
        }, failure: self.signInFailure)
    }

    func signInWithGoogle(wasSuccessful: Bool, accessToken: String?) {
        if wasSuccessful {
            Authentication.sharedInstance.authenticateUser(signInType: .Google, accessToken: accessToken!, success: self.signInSuccess, failure: self.signInFailure)
        } else {
            signInFailure()
        }
    }
    
    func signInSuccess(user: User, session: Session, isNewUser: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

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

    func signInFailure() {
        hideLoginButtons(isHidden: false)
        loadingActivityIndicator.stopAnimating()
    }

    func hideLoginButtons(isHidden: Bool) {
        facebookLoginButton.isHidden = isHidden
        googleLoginButton.isHidden = isHidden
    }
}
