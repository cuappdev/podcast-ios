//
//  LoginViewController.swift
//  Podcast
//
//  Created by Joseph Antonakakis on 9/11/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook Login Button
        let fbLoginFrame = CGRectMake(0, 0, view.frame.width / 1.2, view.frame.height / 10)
        let loginButton = FBSDKLoginButton(frame: fbLoginFrame)
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // Styling
        view.backgroundColor = UIColor.podcastGrayLight
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
