//
//  Authentication.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/15/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

enum AuthenticationEndpointRequestType {
    case signIn
    case merge
}

class Authentication: NSObject, GIDSignInDelegate {

    static var sharedInstance = Authentication()
    var facebookLoginManager: LoginManager!

    var facebookAccessToken: String? {
        get {
            return AccessToken.current?.authenticationToken
        }
    }

    var googleAccessToken: String? {
        get {
            return GIDSignIn.sharedInstance().currentUser?.authentication.accessToken
        }
    }

    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = "724742275706-h8qs46h90squts3dco76p0q6lja2c7nh.apps.googleusercontent.com"

        let profileScope = "https://www.googleapis.com/auth/userinfo.profile"
        let emailScope = "https://www.googleapis.com/auth/userinfo.email"

        GIDSignIn.sharedInstance().scopes.append(contentsOf: [profileScope, emailScope])
        facebookLoginManager = LoginManager()
        GIDSignIn.sharedInstance().delegate = self
    }

    func signInWithFacebook(viewController: UIViewController, success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        facebookLoginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: viewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                failure?()
            case .cancelled:
                print("User cancelled login.")
                failure?()
            case .success(_):
                success?()
            }
        }
    }

    func signInSilentlyWithGoogle() {
         GIDSignIn.sharedInstance().signInSilently()
    }
    
    func signInWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }

    func logout() {
        GIDSignIn.sharedInstance().signOut()
        facebookLoginManager.logOut()
    }

    // Google sign in functionality
    func handleSignIn(url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    // delegate method for Google sign in - called when sign in is complete
    // awkward to put here but this is how Google requires signing in delegation
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // if we are in the LoginViewController
        if let window = UIApplication.shared.delegate?.window as? UIWindow, let navigationController = window.rootViewController as? UINavigationController, let viewController = navigationController.viewControllers.first as? LoginViewController {
            viewController.signInWithGoogle(wasSuccessful: error == nil)
        } else {
            if error == nil {
                // else merge accounts in SettingsPageViewController
                Authentication.sharedInstance.mergeAccounts(signInTypeToMergeIn: .Google, success: { _,_,_ in
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
                    tabBarController.programmaticallyPressTabBarButton(atIndex: System.profileTab)
                }
                , failure: {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
                    tabBarController.programmaticallyPressTabBarButton(atIndex: System.profileTab)
                    tabBarController.currentlyPresentedViewController?.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil)
                })
            }
        }
    }

    // merges account from signInTypeToMergeIn into current account
    func mergeAccounts(signInTypeToMergeIn: SignInType, success: ((User, Session, Bool) -> ())? = nil, failure: (() -> ())? = nil) {
        completeAuthenticationRequest(endpointRequestType: .merge, type: signInTypeToMergeIn, success: success, failure: failure)
    }

    // authenticates the user and executes success block if valid user, else executes failure block
    func authenticateUser(signInType: SignInType, success: ((User, Session, Bool) -> ())? = nil, failure: (() -> ())? = nil) {
        completeAuthenticationRequest(endpointRequestType: .signIn, type: signInType, success: success, failure: failure)
    }

    private func completeAuthenticationRequest(endpointRequestType: AuthenticationEndpointRequestType, type: SignInType, success: ((User, Session, Bool) -> ())? = nil, failure: (() -> ())? = nil) {
        var accessToken: String = ""
        if type == .Google {
            guard let token = Authentication.sharedInstance.googleAccessToken else { return } // Safe to send to the server
            accessToken = token
        } else {
            guard let token = Authentication.sharedInstance.facebookAccessToken else { return } // Safe to send to the server
            accessToken = token
        }

        let endpointRequest: EndpointRequest
        if endpointRequestType == .signIn {
            endpointRequest = AuthenticateUserEndpointRequest(signInType: type, accessToken: accessToken)
        } else  {
            endpointRequest = MergeUserAccountsEndpointRequest(signInType: type, accessToken: accessToken)
        }

        endpointRequest.success = { request in
            guard let result = request.processedResponseValue as? [String: Any],
                let user = result["user"] as? User, let session = result["session"] as? Session, let isNewUser = result["is_new_user"] as? Bool else {
                    print("error authenticating")
                    failure?()
                    return
            }
            System.currentUser = user
            System.currentSession = session
            success?(user, session, isNewUser)
        }

        endpointRequest.failure = { _ in
            failure?()
        }

        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
