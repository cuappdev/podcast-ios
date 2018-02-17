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

    var showSeeAll: Bool?
    var parentTopic: Topic?

    convenience init(seeAll: Bool, parent: Topic? = nil) {
        self.init()
        showSeeAll = seeAll
        parentTopic = parent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = "Topics"
        topicsTableView = UITableView(frame: .zero, style: .plain)
        topicsTableView.tableFooterView = UIView()
        topicsTableView.register(TopicsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        mainScrollView = topicsTableView
        view.addSubview(topicsTableView)
        topicsTableView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
        // todo: populate topics
        topicsTableView.reloadData()

        if let showSubtopics = showSeeAll, let parent = parentTopic, showSubtopics {
            topics.insert(parent, at: 0)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let showSubtopics = showSeeAll, showSubtopics {
            let discoverTopicViewController = DiscoverTopicViewController(topic: topics[indexPath.row])
            navigationController?.pushViewController(discoverTopicViewController, animated: true)
        } else {
            let browseSubtopicsViewController = BrowseTopicsViewController(seeAll: true, parent: topics[indexPath.row])
            browseSubtopicsViewController.topics = topics[indexPath.row].subtopics!
            navigationController?.pushViewController(browseSubtopicsViewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TopicsTableViewCell else { return TopicsTableViewCell() }
        if let parent = parentTopic {
            cell.configure(for: topics[indexPath.row], isParentTopic: parent == topics[indexPath.row])
        } else {
            cell.configure(for: topics[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

}
