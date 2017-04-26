//
//  LoginUsernameViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class LoginUsernameViewController: UIViewController, ChangeUsernameViewDelegate {
    
    var loginBackgroundGradientView: LoginBackgroundGradientView!
    var changeUsernameView: ChangeUsernameView!
    var user: User!
    
    //Constants
    var changeUsernameViewHeight: CGFloat = 172
    var changeUsernameViewWidth: CGFloat = 248
    var changeUsernameViewY: CGFloat = 362
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBackgroundGradientView = LoginBackgroundGradientView(frame: view.frame)
        view.addSubview(loginBackgroundGradientView)
        
        
        changeUsernameView = ChangeUsernameView(frame: CGRect(x: 0, y: changeUsernameViewY, width: changeUsernameViewWidth, height: changeUsernameViewHeight), user: user)
        changeUsernameView.center.x = view.center.x
        changeUsernameView.delegate = self
        view.addSubview(changeUsernameView)
    }
    
    
    func changeUsernameViewTextFieldDidEndEditing(changeUsernameView: ChangeUsernameView, username: String) {
        let changeUsernameEndpointRequest = ChangeUsernameEndpointRequest(username: username)
        changeUsernameEndpointRequest.success = { (endpointRequest: EndpointRequest) in
            changeUsernameView.changeUsernameSuccess()
        }
        
        changeUsernameEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
            print("username change unsuccessful")
            changeUsernameView.changeUsernameFailure()
        }
        System.endpointRequestQueue.addOperation(changeUsernameEndpointRequest)
    }
    
    func continueButtonPress(changeUsernameView: ChangeUsernameView) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.didFinishAuthenticatingUser()
    }
}
