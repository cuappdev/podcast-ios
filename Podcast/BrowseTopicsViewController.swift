//
//  BrowseTopicsViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 12/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

/// Displays a list of topics from either the DiscoverViewController or from a parent BrowseTopicsViewController.
class BrowseTopicsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    let reuseIdentifier = "Reuse"
    let rowHeight: CGFloat = 54

    var topics: [Topic] = []
    var topicsTableView: UITableView!

    var isShowingSubtopics: Bool? // whether or not to show the "See All ____" with children subtopics
    var parentTopic: Topic?

    convenience init(showSubtopics: Bool, parent: Topic? = nil) {
        self.init()
        isShowingSubtopics = showSubtopics
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

        if let showSubtopics = isShowingSubtopics, let parent = parentTopic, showSubtopics {
            // add parent "See All ____" topic option
            topics.insert(parent, at: 0)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let showSubtopics = isShowingSubtopics, showSubtopics {
            let discoverTopicViewController = DiscoverTopicViewController(topic: topics[indexPath.row])
            navigationController?.pushViewController(discoverTopicViewController, animated: true)
        } else {
            if let subtopics = topics[indexPath.row].subtopics, subtopics.count > 0 {
                let browseSubtopicsViewController = BrowseTopicsViewController(showSubtopics: true, parent: topics[indexPath.row])
                browseSubtopicsViewController.topics = subtopics
                navigationController?.pushViewController(browseSubtopicsViewController, animated: true)
            } else {
                let discoverTopicViewController = DiscoverTopicViewController(topic: topics[indexPath.row])
                navigationController?.pushViewController(discoverTopicViewController, animated: true)
            }
        }
    }

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
