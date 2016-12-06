//
//  LoginViewController.swift
//  Podcast
//
//  Created by Joseph Antonakakis on 9/11/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    
    /* Required */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook Login Button
        let loginButton = UIButton(type: .custom)
        loginButton.backgroundColor = .podcastWhite
        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        loginButton.center = view.center;
        loginButton.layer.borderColor = UIColor.podcastGrayLight.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 3
        loginButton.setTitle("Login With Facebook", for: .normal)
        loginButton.setTitleColor(.podcastGrayLight, for: .normal)
        loginButton.addTarget(self, action: #selector(self.loginToFacebook), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(loginButton)
        
        // Background
        view.backgroundColor = .podcastWhite
        
    }
    
    /* Required */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Handles authenticating with Facebook */
    func loginToFacebook() {

        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                break
            case .cancelled:
                print("User cancelled login.")
                break
            case .success(grantedPermissions: _, declinedPermissions: _, token: let authToken):
                LoginViewController.setFBUser(authToken: authToken.authenticationToken)
                break
            }
        
        }
    }
    
    /* Communicates with backend and gets backend session info */
    static func setFBUser (authToken: String) {
        REST.userByFBToken(token: authToken, completion: { (data, error) in
            User.currentUser.fillFields(data: data)
        })
    }
    
}








