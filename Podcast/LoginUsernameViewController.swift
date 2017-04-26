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
    var podcastLogoView: LoginPodcastLogoView!
    var changeUsernameView: ChangeUsernameView!
    var user: User!
    
    //Constants
    var changeUsernameViewHeight: CGFloat = 172
    var changeUsernameViewWidth: CGFloat = 248
    var changeUsernameViewY: CGFloat = 362
    var changeUsernameViewKeyboardActiveY: CGFloat = 5/8 * 362
    var podcastLogoViewY: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBackgroundGradientView = LoginBackgroundGradientView(frame: view.frame)
        view.addSubview(loginBackgroundGradientView)
        
        podcastLogoView = LoginPodcastLogoView(frame: CGRect(x: 0, y: podcastLogoViewY, width: view.frame.width, height: view.frame.height / 4))
        podcastLogoView.center.x = view.center.x
        view.addSubview(podcastLogoView)
        
        changeUsernameView = ChangeUsernameView(frame: CGRect(x: 0, y: changeUsernameViewY, width: changeUsernameViewWidth, height: changeUsernameViewHeight), user: user)
        changeUsernameView.center.x = view.center.x
        changeUsernameView.delegate = self
        view.addSubview(changeUsernameView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    func changeUsernameViewTextFieldDidEndEditing(changeUsernameView: ChangeUsernameView, username: String) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.podcastLogoView.frame.origin.y += (self.changeUsernameViewY - self.changeUsernameViewKeyboardActiveY)
            self.changeUsernameView.frame.origin.y = self.changeUsernameViewY
        }, completion: nil)
        
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
    
    func changeUsernameViewTextFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.podcastLogoView.frame.origin.y -= (self.changeUsernameViewY - self.changeUsernameViewKeyboardActiveY)
            self.changeUsernameView.frame.origin.y = self.changeUsernameViewKeyboardActiveY
        }, completion: nil)
    }
}
