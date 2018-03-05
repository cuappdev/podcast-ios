//
//  PrivacyPolicyViewController.swift
//  Podcast
//
//  Created by Jack Thompson on 3/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView!
    
    var privacyPolicyURL = "http://www.cornellappdev.com/recast-privacy-policy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView(frame: view.frame)
        webView.delegate = self
        view.addSubview(webView)
        
        openURL(urlString: privacyPolicyURL)
    }
    
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
