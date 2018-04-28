//
//  ToolTipLabel.swift
//  Podcast
//
//  Created by Mindy Lou on 4/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

enum ToolTipType {
    case notificationsOn
    case notificationsOff
    case tapBellIcon

    var headerText: String? {
        switch self {
        case .notificationsOff:
            return "Notifications Off"
        case .notificationsOn:
            return "Notifications On"
        case .tapBellIcon:
            return nil
        }
    }

    var image: UIImage {
        switch self {
        case .notificationsOn, .tapBellIcon:
            return #imageLiteral(resourceName: "subscriptionsOn")
        case .notificationsOff:
            return #imageLiteral(resourceName: "subscriptionsOff")
        }
    }

    var descriptionText: String {
        switch self {
        case .notificationsOff:
            return "You will no longer receive a notification when a new episode is released."
        case .notificationsOn:
            return "You will receive a notification every time an episode is released."
        case .tapBellIcon:
            return "Tap the bell icon to receive notifications for new episode releases."
        }
    }

    func descriptionText(for series: Series) -> String {
        switch self {
        case .notificationsOff:
            return "You will no longer receive a notification when \(series.title) releases a new episode."
        case .notificationsOn:
            return "You will receive a notification every time \(series.title) releases a new episode."
        case .tapBellIcon:
            return "Tap the bell icon to receive notifications for new episode releases."
        }
    }

    var height: CGFloat {
        switch self {
        case .notificationsOff, .notificationsOn:
            return 160
        case .tapBellIcon:
            return 92
        }
    }
}

class ToolTipView: UIView {
    var tooltipView: UIView!
    var headerTextLabel: UILabel!
    var descriptionTextLabel: UILabel!
    var confirmButton: UIButton?
    var imageView: UIImageView!
    var blueLabelView: UIImageView?
    var buttonSeparatorLabel: UILabel?
    var cancelButton: UIButton?

    let toolTipHeight: CGFloat = 13
    let toolTipHalfWidth: CGFloat = 9
    let imageOffset: CGFloat = 18
    let textLeadingOffset: CGFloat = 12
    let buttonSeparatorOffset: CGFloat = 18.5
    let buttonHeight: CGFloat = 47
    let textHeaderTopOffset: CGFloat = 21
    let imageViewSize = CGSize(width: 48, height: 48)
    let cancelButtonSize = CGSize(width: 8, height: 8)
    var descriptionTrailingInset: CGFloat = 0

    init(with type: ToolTipType, for series: Series) {
        super.init(frame: .zero)
        layer.masksToBounds = false

        descriptionTrailingInset = type == .tapBellIcon ? 45 : 18

        tooltipView = UIView()
        tooltipView.backgroundColor = .offWhite
        addSubview(tooltipView)

        headerTextLabel = UILabel()
        headerTextLabel.numberOfLines = 0
        headerTextLabel.font = ._14SemiboldFont()
        headerTextLabel.textColor = .charcoalGrey
        headerTextLabel.text = type.headerText
        tooltipView.addSubview(headerTextLabel)

        descriptionTextLabel = UILabel()
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.font = ._14RegularFont()
        descriptionTextLabel.textColor = .slateGrey
        descriptionTextLabel.text = type.descriptionText
        tooltipView.addSubview(descriptionTextLabel)

        if type == .notificationsOn || type == .tapBellIcon {
            blueLabelView = UIImageView(image: #imageLiteral(resourceName: "blueRectangle"))
            addSubview(blueLabelView!)
        }

        imageView = UIImageView(image: type.image)
        tooltipView.addSubview(imageView)

        if type == .notificationsOn || type == .notificationsOff {
            buttonSeparatorLabel = UILabel()
            buttonSeparatorLabel?.backgroundColor = .paleGrey
            tooltipView.addSubview(buttonSeparatorLabel!)

            confirmButton = UIButton()
            confirmButton?.backgroundColor = .offWhite
            confirmButton?.setTitle("I understand", for: .normal)
            confirmButton?.titleLabel?.font = ._14RegularFont()
            confirmButton?.setTitleColor(.slateGrey, for: .normal)
            confirmButton?.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            tooltipView.addSubview(confirmButton!)
        }

        if type == .tapBellIcon {
            cancelButton = Button()
            cancelButton?.setImage(#imageLiteral(resourceName: "dismiss_banner"), for: .normal)
            cancelButton?.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            tooltipView.addSubview(cancelButton!)
        }

        setupConstraints()
    }

    override func layoutSubviews() {
        addDropShadow()
    }

    // set the pointing part of the tooltip
    func setBezierPoint(to point: CGPoint) {
        let triangleBez = UIBezierPath()
        triangleBez.move(to: point)
        triangleBez.addLine(to: CGPoint(x: point.x - toolTipHalfWidth, y: point.y + toolTipHeight))
        triangleBez.addLine(to: CGPoint(x: point.x + toolTipHalfWidth, y: point.y + toolTipHeight))
        triangleBez.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = triangleBez.cgPath
        shapeLayer.fillColor = UIColor.offWhite.cgColor
        layer.addSublayer(shapeLayer)
    }

    func setupConstraints() {
        tooltipView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(toolTipHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(imageOffset)
            make.size.equalTo(imageViewSize)
        }

        blueLabelView?.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(imageView)
        }

        headerTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(textLeadingOffset).priority(999)
            make.trailing.equalToSuperview().inset(imageOffset)
            make.top.equalToSuperview().offset(textHeaderTopOffset)
        }

        descriptionTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerTextLabel).priority(999)
            make.trailing.equalToSuperview().inset(descriptionTrailingInset)
            make.top.equalTo(headerTextLabel.snp.bottom)
        }

        buttonSeparatorLabel?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(descriptionTextLabel.snp.bottom).offset(buttonSeparatorOffset)
        }

        confirmButton?.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonSeparatorLabel?.snp.bottom ?? descriptionTextLabel.snp.bottom)
            make.height.equalTo(buttonHeight)
        }

        cancelButton?.snp.makeConstraints { make in
            make.size.equalTo(cancelButtonSize)
            make.top.trailing.equalToSuperview().inset(imageOffset)
        }

    }

    func addDropShadow() {
        tooltipView.layer.masksToBounds = false
        tooltipView.layer.shadowColor = UIColor.black.cgColor
        tooltipView.layer.shadowOffset = CGSize(width: 0, height: 12)
        tooltipView.layer.shadowOpacity = 0.15
        tooltipView.layer.shadowRadius = 24
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismiss() {
        removeFromSuperview()
    }
    
}
