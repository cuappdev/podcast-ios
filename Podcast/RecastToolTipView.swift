////
////  ToolTipViewController.swift
////  Podcast
////
////  Created by Natasha Armbrust on 5/13/18.
////  Copyright © 2018 Cornell App Development. All rights reserved.
////
//
//import UIKit
//
//class ToolTipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var tableView: UITableView!
//
//    let toolTipHeight: CGFloat = 13
//    let toolTipHalfWidth: CGFloat = 9
//
//    init() {
//        super.init(coder: .zero)
//        view.layer.masksToBounds = false
//
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        addSubview(tableView)
//
//        setupConstraints()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //addDropShadow(xOffset: 0, yOffset: 12, opacity: 0.15, radius: 24)
//    }
//
//    // set the pointing part of the tooltip
//    func setBezierPoint(to point: CGPoint) {
//        let triangleBez = UIBezierPath()
//        triangleBez.move(to: point)
//        triangleBez.addLine(to: CGPoint(x: point.x - toolTipHalfWidth, y: point.y + toolTipHeight))
//        triangleBez.addLine(to: CGPoint(x: point.x + toolTipHalfWidth, y: point.y + toolTipHeight))
//        triangleBez.close()
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = triangleBez.cgPath
//        shapeLayer.fillColor = UIColor.offWhite.cgColor
//        layer.addSublayer(shapeLayer)
//    }
//
//    func setupConstraints() {
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc func dismiss() {
//        removeFromSuperview()
//    }
//}
