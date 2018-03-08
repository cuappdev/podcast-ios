
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
    let podcastLogoViewMultiplier: CGFloat = 0.25

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
            make.height.equalToSuperview().multipliedBy(podcastLogoViewMultiplier)
            make.top.equalTo(0).inset(view.frame.width * podcastLogoViewMultiplier)
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
        if let _ = Authentication.sharedInstance.facebookAccessToken {
            // try signing in with Facebook
            Authentication.sharedInstance.authenticateUser(signInType: .Facebook, success: self.signInSuccess, failure: { self.hideLoginButtons(isHidden: false) })
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
            Authentication.sharedInstance.authenticateUser(signInType: .Facebook, success: self.signInSuccess, failure: self.signInFailure)
        }, cancelled: {
            self.loadingActivityIndicator.stopAnimating()
            self.hideLoginButtons(isHidden: false) },
           failure: self.signInFailure)
    }

    func signInWithGoogle(withError error: Error?) {
        switch(error) {
        case .none:
            Authentication.sharedInstance.authenticateUser(signInType: .Google, success: self.signInSuccess, failure: self.signInFailure)
        case .some(let googleError):
            switch(googleError.code) {
            case GIDSignInErrorCode.canceled.rawValue, GIDSignInErrorCode.hasNoAuthInKeychain.rawValue:
                loadingActivityIndicator.stopAnimating()
                hideLoginButtons(isHidden: false)
                break
            default:
                 signInFailure()
            }
        }
    }
    
    func signInSuccess(isNewUser: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        loadingActivityIndicator.stopAnimating()
        hideLoginButtons(isHidden: false)

        if isNewUser {
            let loginUsernameVC = LoginUsernameViewController()
            loginUsernameVC.user = System.currentUser!
            navigationController?.pushViewController(loginUsernameVC, animated: false)
        } else {
            appDelegate.didFinishAuthenticatingUser()
        }
    }

    func signInFailure() {
        loadingActivityIndicator.stopAnimating()
        hideLoginButtons(isHidden: false)
        present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil)
    }

    func hideLoginButtons(isHidden: Bool) {
        facebookLoginButton.isHidden = isHidden
        googleLoginButton.isHidden = isHidden
    }
}
