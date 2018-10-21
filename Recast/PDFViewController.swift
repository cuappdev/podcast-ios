//
//  PDFViewController.swift
//  Recast
//
//  Created by Drew Dunne on 10/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    var webView: UIWebView!

    var pdf: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView()
        view.addSubview(webView)

        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        webView.loadRequest(URLRequest(url: pdf))
    }

}
