//
//  OnboardingViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/28/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    var gradientBackgroundView: LoginBackgroundGradientView!
    let types: [OnboardingType] = [.discover, .connect, .recast]
    let onboardingViews: [OnboardingView]!
    var onboardingDotStackView: UIStackView!
    var nextButton: OnboardingButton!
    var prevButton: OnboardingButton!

    let onboardingButtonHeight: CGFloat = 42
    let onboardingButtonWidth: CGFloat = 120
    let onboardingButtonBottomPadding: CGFloat = 120
    let onboardingButtonPadding: CGFloat = 20
    let isDisabledAlpha: CGFloat = 0.30

    var selectedIndex: Int = 0

    init() {
        onboardingViews = types.map({ type in OnboardingView(type: type)})
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        gradientBackgroundView = LoginBackgroundGradientView(frame: view.frame)
        view.addSubview(gradientBackgroundView)

        onboardingDotStackView = UIStackView(arrangedSubviews: types.map({ _ in OnboardingDotView()}))
        onboardingDotStackView.axis = .horizontal
        onboardingDotStackView.distribution = .fillEqually
        onboardingDotStackView.alignment = .fill
        onboardingDotStackView.spacing = OnboardingDotView.size
        view.addSubview(onboardingDotStackView)

        for onboardingView in onboardingViews {
            view.addSubview(onboardingView)

            onboardingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        let tempView = UIView()
        nextButton = OnboardingButton(title: "Next")
        nextButton.addTarget(self, action: #selector(nextPress), for: .touchUpInside)
        tempView.addSubview(nextButton)

        prevButton =  OnboardingButton(title: "Previous")
        prevButton.addTarget(self, action: #selector(prevPress), for: .touchUpInside)
        tempView.addSubview(prevButton)

        view.addSubview(tempView)

        nextButton.snp.makeConstraints { make in
            make.bottom.top.trailing.equalToSuperview()
            make.width.equalTo(onboardingButtonWidth)
            make.height.equalTo(onboardingButtonHeight)
            make.leading.equalTo(prevButton.snp.trailing).offset(onboardingButtonPadding)
        }

        prevButton.snp.makeConstraints { make in
            make.bottom.top.leading.equalToSuperview()
            make.width.equalTo(onboardingButtonWidth)
            make.height.equalTo(onboardingButtonHeight)
        }

        // temp view to constraint buttons correctly
        tempView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(onboardingButtonBottomPadding)
        }

        onboardingDotStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).inset(onboardingButtonBottomPadding)
            make.height.equalTo(OnboardingDotView.size)
            make.width.equalTo(CGFloat(types.count) * OnboardingDotView.size + CGFloat(types.count - 1) * OnboardingDotView.size)
        }

        updateSelectedIndex()
    }

    @objc func nextPress() {
        selectedIndex += 1
        if selectedIndex >= types.count {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.finishedOnboarding()
            return
        }
        updateSelectedIndex()
    }

    @objc func prevPress() {
        selectedIndex = selectedIndex > 0 ? selectedIndex - 1 : 0 // don't go out of bounds
        updateSelectedIndex()
    }

    func updateSelectedIndex() {
        for (i,onboardingView) in onboardingViews.enumerated() {
            onboardingView.isHidden = i != selectedIndex
            (onboardingDotStackView.arrangedSubviews[i] as! OnboardingDotView).isSelected(i == selectedIndex)
        }
        prevButton.alpha = selectedIndex == 0 ? isDisabledAlpha : 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
