//
//  BrowseTopicsViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 12/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class BrowseTopicsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    let reuseIdentifier = "Reuse"
    let rowHeight: CGFloat = 54

    var topics: [Topic] = []
    var topicsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = "Topics"
        topicsTableView = UITableView(frame: .zero, style: .plain)
        topicsTableView.tableFooterView = UIView()
        topicsTableView.register(TopicsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        view.addSubview(topicsTableView)
        topicsTableView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
        // todo: populate topics
        topicsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TopicsTableViewCell else { return TopicsTableViewCell() }
        cell.configure(for: topics[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

}
