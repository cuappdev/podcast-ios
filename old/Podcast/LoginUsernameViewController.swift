//
//  LoginUsernameViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class LoginUsernameViewController: UIViewController {
    
    var loginBackgroundGradientView: LoginBackgroundGradientView!
    var podcastLogoView: LoginPodcastLogoView!
    var changeUsernameView: ChangeUsernameView!
    var user: User!
    
    // MARK: Constants
    var changeUsernameViewHeight: CGFloat = 172
    var changeUsernameViewWidth: CGFloat = 300
    var changeUsernameViewOffsetMultiplier: CGFloat = 362/667
    var changeUsernameViewKeyboardActiveY: CGFloat = 5/8 * 362
    var podcastLogoViewOffset: CGFloat = 140
    let podcastLogoMultiplier: CGFloat = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBackgroundGradientView = LoginBackgroundGradientView(frame: view.frame)
        view.addSubview(loginBackgroundGradientView)

        podcastLogoView = LoginPodcastLogoView()
        view.addSubview(podcastLogoView)
        podcastLogoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(podcastLogoViewOffset)
            make.height.equalToSuperview().multipliedBy(podcastLogoMultiplier)
        }
        
        changeUsernameView = ChangeUsernameView(frame: CGRect(x: 0, y: 0, width: changeUsernameViewWidth, height: changeUsernameViewHeight), user: user)
        changeUsernameView.delegate = self
        view.addSubview(changeUsernameView)
        changeUsernameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(changeUsernameViewOffsetMultiplier * view.frame.height)
            make.width.equalTo(changeUsernameViewWidth)
            make.height.equalTo(changeUsernameViewHeight)
        }
    }
}

// MARK: ChangeUsernameView Delegate
extension LoginUsernameViewController: ChangeUsernameViewDelegate {

    func changeUsernameViewTextFieldDidEndEditing(changeUsernameView: ChangeUsernameView, username: String) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.podcastLogoView.frame.origin.y += (self.changeUsernameView.frame.maxY - self.changeUsernameViewKeyboardActiveY)
            self.changeUsernameView.frame.origin.y = self.changeUsernameView.frame.maxY
        }, completion: nil)

        System.currentUser!.changeUsername(username: username, success: changeUsernameView.changeUsernameSuccess, failure: changeUsernameView.changeUsernameFailure)
    }
    
    func changeUsernameViewTextFieldDidChange(changeUsernameView: ChangeUsernameView, username: String) {
        System.currentUser!.changeUsername(username: username, success: changeUsernameView.changeUsernameSuccess, failure: changeUsernameView.changeUsernameFailure)
    }
    
    func continueButtonPress(changeUsernameView: ChangeUsernameView) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.startOnboarding()
    }
    
    func changeUsernameViewTextFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.podcastLogoView.frame.origin.y -= (self.changeUsernameView.frame.minY - self.changeUsernameViewKeyboardActiveY)
            self.changeUsernameView.frame.origin.y = self.changeUsernameViewKeyboardActiveY
        }, completion: nil)
    }
}
