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

enum SignInResult {
    case success
    case cancelled
    case failure

    // to convert from Facebook result
    static func conversion(from loginResult: LoginResult) -> SignInResult {
        switch(loginResult) {
        case .cancelled:
            return SignInResult.cancelled
        case .failed:
            return SignInResult.failure
        case .success:
            return SignInResult.success
        }
    }

    // to convert from Google error
    static func conversion(from error: Error?) -> SignInResult {
        switch(error) {
        case .none:
            return SignInResult.success
        case .some(let googleError):
            switch(googleError.code) {
            case GIDSignInErrorCode.canceled.rawValue, GIDSignInErrorCode.hasNoAuthInKeychain.rawValue:
                return SignInResult.cancelled
            default:
                return SignInResult.failure
            }
        }
    }
}

protocol SignInUIDelegate: class {
    func signedIn(for type: SignInType, withResult result: SignInResult)
}

class Authentication: NSObject, GIDSignInDelegate {

    static var sharedInstance = Authentication()
    var facebookLoginManager: LoginManager!
    private weak var delegate: SignInUIDelegate?

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
        facebookLoginManager.loginBehavior = .web
        GIDSignIn.sharedInstance().delegate = self
    }

    func setDelegate(_ viewController: UIViewController) {
        if let _ = viewController as? GIDSignInUIDelegate, let _ = viewController as? SignInUIDelegate {
            delegate = viewController as? SignInUIDelegate
            GIDSignIn.sharedInstance().uiDelegate = viewController as! GIDSignInUIDelegate
        }
    }

    func signIn(with type: SignInType, viewController: UIViewController) {
        switch(type) {
        case .Facebook:
            facebookLoginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: viewController) { loginResult in
                self.delegate?.signedIn(for: .Facebook, withResult: SignInResult.conversion(from: loginResult))
            }
        case .Google:
            GIDSignIn.sharedInstance().signIn()
        }
    }

    func signInSilentlyWithGoogle() {
         GIDSignIn.sharedInstance().signInSilently()
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
        delegate?.signedIn(for: .Google, withResult: SignInResult.conversion(from: error))
    }

    // merges account from signInTypeToMergeIn into current account
    func mergeAccounts(signInTypeToMergeIn: SignInType, success: ((Bool) -> ())? = nil, failure: (() -> ())? = nil) {
        completeAuthenticationRequest(endpointRequestType: .merge, type: signInTypeToMergeIn, success: success, failure: failure)
    }

    // authenticates the user and executes success block if valid user, else executes failure block
    func authenticateUser(signInType: SignInType, success: ((Bool) -> ())? = nil, failure: (() -> ())? = nil) {
        completeAuthenticationRequest(endpointRequestType: .signIn, type: signInType, success: success, failure: failure)
    }

    private func completeAuthenticationRequest(endpointRequestType: AuthenticationEndpointRequestType, type: SignInType, success: ((Bool) -> ())? = nil, failure: (() -> ())? = nil) {
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

        switch(endpointRequestType) { // merge accounts gives us back different results for success
        case .merge:
            endpointRequest.success = { request in
                guard let user = request.processedResponseValue as? User else {
                        print("error authenticating")
                        failure?()
                        return
                }
                System.currentUser = user
                success?(false) // not new user
            }
            break
        default:
            endpointRequest.success = { request in
                guard let result = request.processedResponseValue as? [String: Any],
                    let user = result["user"] as? User, let session = result["session"] as? Session, let isNewUser = result["is_new_user"] as? Bool else {
                        print("error authenticating")
                        failure?()
                        return
                }
                System.currentUser = user
                System.currentSession = session
                success?(isNewUser)
            }
        }


        endpointRequest.failure = { _ in
            failure?()
        }

        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
