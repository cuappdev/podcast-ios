//
//  AboutRecastViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SafariServices

// Taken from TCAT credit Ji Hwan Seung on 19/11/2017
class AboutRecastViewController: ViewController {

    let recastImageSize: CGFloat = 120
    let padding: CGFloat = 44
    let smallPadding: CGFloat = 8

    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var recastImage = UIImageView()

    var tableView = UITableView(frame: .zero, style: .grouped)
    let identifier = "identifier"

    var content: [[(name: String, action: Selector)]] = [
        [ // Section 0
            (name: "Visit Our Website", action: #selector(openTeamWebsite)),
            (name: "We're Open Source!", action: #selector(openGithubWebsite)),
            (name: "Send Feedback", action: #selector(openBugReportForm))
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About Us"

        view.backgroundColor = .paleGrey

        view.addSubview(recastImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(tableView)

        recastImage.image = #imageLiteral(resourceName: "logo")
        recastImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(recastImageSize)
            make.top.equalToSuperview().offset(padding + ((navigationController?.navigationBar.frame.maxY) ?? 0))
        }
        recastImage.layer.cornerRadius = recastImageSize / 2
        recastImage.clipsToBounds = true

        titleLabel.font = ._16SemiboldFont()
        titleLabel.textColor = .charcoalGrey
        titleLabel.text = "Made by Cornell App Development"
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(recastImage.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.textColor = .charcoalGrey
        descriptionLabel.text = "An Engineering Project Team\nat Cornell University"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textAlignment = .center
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(smallPadding)
            make.centerX.equalToSuperview()
        }

        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .paleGrey
        tableView.isScrollEnabled = false
        tableView.rowHeight = SettingsTableViewCell.height
        tableView.showsVerticalScrollIndicator = false

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        mainScrollView = tableView
    }

    // MARK: Functions

    @objc func openBugReportForm() {
        open(Keys.reportFeedbackURL.value)
    }

    @objc func openGithubWebsite() {
        open(Keys.githubURL.value)
    }

    @objc func openTeamWebsite() {
        open(Keys.appDevURL.value)
    }

    func open(_ url: String, inApp: Bool = true) {

        guard let URL = URL(string: url) else {
            return
        }

        if inApp {
            let safariViewController = SFSafariViewController(url: URL)
            present(safariViewController, animated: true)
        } else {
            UIApplication.shared.open(URL)
        }
    }

}

// MARK: TableView Data Source

extension AboutRecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Initalize and format cell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SettingsTableViewCell
        cell.selectionStyle = .none

        // Set cell content
        cell.setTitle(content[indexPath.section][indexPath.row].name)

        // Set custom formatting based on cell
        switch (indexPath.section, indexPath.row) {

        case (0, 2): // Send feedback
            cell.titleLabel?.textColor = .sea
        default:
            break

        }
        return cell
    }

}

// MARK: TableView Delegate

extension AboutRecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selector = content[indexPath.section][indexPath.row].action
        performSelector(onMainThread: selector, with: nil, waitUntilDone: false)
    }

}
