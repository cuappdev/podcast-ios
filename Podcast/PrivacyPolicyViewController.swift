//
//  PrivacyPolicyViewController.swift
//  Podcast
//
//  Created by Jack Thompson on 3/5/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class PrivacyPolicyViewController: ViewController, UIWebViewDelegate {

    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
        
        webView = UIWebView()
        webView.delegate = self
        view.addSubview(webView)
        mainScrollView = webView.scrollView
        
        webView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        openURL(urlString: System.keys.privacyPolicyURL)
    }
    
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.loadRequest(request)
        }
    }
}
