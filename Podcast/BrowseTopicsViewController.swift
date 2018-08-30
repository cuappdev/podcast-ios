//
//  BrowseTopicsViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 12/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

/// Displays a list of topics from either the DiscoverViewController or from a parent BrowseTopicsViewController.
class BrowseTopicsViewController: ViewController {

    let reuseIdentifier = "BrowseTopicsTableViewCellIdentifier"
    let rowHeight: CGFloat = 54

    var topics: [Topic] = []
    var topicsTableView: UITableView!

    // will be non-nil if currently showing "See All" and subtopics
    var parentTopic: Topic?

    convenience init(parent: Topic) {
        self.init()
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
        topicsTableView.backgroundColor = .offWhite
        mainScrollView = topicsTableView
        view.addSubview(topicsTableView)
        topicsTableView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }

        if let parent = parentTopic {
            // add parent "See All ____" topic option
            topics.insert(parent, at: 0)
        }
    }

}

// MARK: TableView Data Source
extension BrowseTopicsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TopicsTableViewCell else { return TopicsTableViewCell() }
        if let parent = parentTopic {
            cell.configure(for: topics[indexPath.row], isParentTopic: parent == topics[indexPath.row], parentTopic: parentTopic)
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

// MARK: TableView Delegate
extension BrowseTopicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // currently on parent topic, browse the subtopic
        if let parent = parentTopic {
            let discoverTopicViewController = DiscoverTopicViewController(topic: topics[indexPath.row], parentTopic: parent)
            navigationController?.pushViewController(discoverTopicViewController, animated: true)
        } else if let subtopics = topics[indexPath.row].subtopics, !subtopics.isEmpty {
            // view subtopics of current topic
            let browseSubtopicsViewController = BrowseTopicsViewController(parent: topics[indexPath.row])
            browseSubtopicsViewController.topics = subtopics
            navigationController?.pushViewController(browseSubtopicsViewController, animated: true)
        } else {
            let discoverTopicViewController = DiscoverTopicViewController(topic: topics[indexPath.row])
            navigationController?.pushViewController(discoverTopicViewController, animated: true)
        }
    }
}
