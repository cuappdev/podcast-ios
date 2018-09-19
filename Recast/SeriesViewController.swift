//
//  SeriesViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/15/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class SeriesViewController: UIViewController {

    // MARK: - Variables
    var headerView: SeriesHeaderView!
    var episodeTableView: UITableView!

    // MARK: - Constants
    let episodeCellReuseIdentifer = "episodeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        headerView = SeriesHeaderView(frame: .zero)

        episodeTableView = UITableView()
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        episodeTableView.rowHeight = UITableViewAutomaticDimension
        episodeTableView.tableHeaderView = headerView

        view.addSubview(episodeTableView)

        layoutSubviews()
    }

    func layoutSubviews() {
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide)
        }
        episodeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        episodeTableView.tableHeaderView?.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - episodeTableView DataSource
extension SeriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return EpisodeTableViewCell(style: .default, reuseIdentifier: episodeCellReuseIdentifer)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - episodeTableView Delegate
extension SeriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = PlayerViewController()
        self.present(player, animated: true, completion: nil)
    }
}
