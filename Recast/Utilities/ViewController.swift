//
//  ViewController.swift
//  Recast
//
//  Created by Jack Thompson on 11/20/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

enum NavBarType {
    case `default`
    case custom
    case hidden
}

class ViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Variables
    var customNavBar: CustomNavigationBar?

    var navBarType: NavBarType = .default {
        didSet {
            setNavBar(navBarType)
        }
    }

    var mainScrollView: UIScrollView? {
        didSet {
            if navBarType == .custom {
                mainScrollView?.delegate = self
                mainScrollView?.contentInsetAdjustmentBehavior = .never
                mainScrollView?.contentInset = self.additionalSafeAreaInsets
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(navBarType)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar(navBarType)
    }

    func setNavBar(_ type: NavBarType) {
        switch type {
        case .default:
            setDefaultNavBar()
        case .custom:
            removeNavBar()
            if let navBar = customNavBar {
                navBar.isHidden = false
            } else {
                addCustomNavBar()
            }
        case .hidden:
            removeNavBar()
        }
    }

    func setDefaultNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.isTranslucent = false
    }

    func removeNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = true
    }

    func addCustomNavBar() {
        customNavBar = CustomNavigationBar()
        customNavBar?.title = navigationItem.title
        navigationItem.title = nil
        view.addSubview(customNavBar!)

        customNavBar?.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(CustomNavigationBar.height).priority(999)
            make.height.greaterThanOrEqualTo(CustomNavigationBar.smallHeight)
        }

        // `mainScrollView` insets for when using custom navigation bar
        var newSafeArea = view.safeAreaInsets
        newSafeArea.top = CustomNavigationBar.height
        newSafeArea.bottom = AppDelegate.appDelegate.tabBarController.tabBar.frame.height
        self.additionalSafeAreaInsets = newSafeArea
        viewSafeAreaInsetsDidChange()
    }

    /// Resizes Custom Navigation Bar upon scrolling, if `navBarType = .custom`.
    dynamic func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customNavBar?.snp.updateConstraints { update in
            update.height.equalTo(-scrollView.contentOffset.y).priority(999)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // keep navigation bar on top
        if let navBar = customNavBar {
            view.bringSubviewToFront(navBar)
        }
    }

}
