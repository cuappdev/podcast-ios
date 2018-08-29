//
//  ListeningHistoryViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/24/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class ListeningHistoryViewController: ViewController {
    
    // MARK: Constants

    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    // MARK: Variables
    
    var listeningHistoryTableView: EmptyStateTableView! // not a delegate because no action button
    var episodes: [Episode] = []
    var episodeSet = Set<Episode>()
    var continueInfiniteScroll: Bool = true
    let pageSize: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Listening History"
        
        //tableview
        listeningHistoryTableView = EmptyStateTableView(frame: view.frame, type: .listeningHistory, isRefreshable: true)
        listeningHistoryTableView.delegate = self
        listeningHistoryTableView.dataSource = self
        listeningHistoryTableView.emptyStateTableViewDelegate = self
        listeningHistoryTableView.register(ListeningHistoryTableViewCell.self, forCellReuseIdentifier: "ListeningHistoryTableViewCellIdentifier")
        view.addSubview(listeningHistoryTableView)
        listeningHistoryTableView.rowHeight = ListeningHistoryTableViewCell.height
        listeningHistoryTableView.reloadData()
        mainScrollView = listeningHistoryTableView
        
        listeningHistoryTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        listeningHistoryTableView.addInfiniteScroll { tableView in
            self.fetchEpisodes(refresh: false)
        }
        //tells the infinite scroll when to stop
        listeningHistoryTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }

        self.fetchEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listeningHistoryTableView.reloadData()
    }

    // MARK: Endpoint Requests
    
    func emptyStateTableViewHandleRefresh() {
        fetchEpisodes()
    }

    func fetchEpisodes(refresh: Bool = true) {
        let offset: Int
        if refresh {
            offset = 0
        } else {
            offset = self.episodes.count
        }
        let historyRequest = FetchListeningHistoryEndpointRequest(offset: offset, max: pageSize)
        historyRequest.success = { request in
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            var episodesToAdd: [Episode] = []
            for episode in newEpisodes {
                if !self.episodeSet.contains(episode) { //only add episodes we haven't seen
                    episodesToAdd.append(episode)
                    self.episodeSet.insert(episode)
                }
            }
            if refresh { //if we are at a pull to refresh add episodes to beginning
                self.episodes = episodesToAdd + self.episodes
            } else {
                self.episodes = self.episodes + episodesToAdd
            }
            if episodesToAdd.isEmpty && !refresh { self.continueInfiniteScroll = false }
            self.listeningHistoryTableView.endRefreshing()
            self.listeningHistoryTableView.stopLoadingAnimation()
            self.listeningHistoryTableView.finishInfiniteScroll()
            self.listeningHistoryTableView.reloadData()
        }

        historyRequest.failure = { _ in
            self.listeningHistoryTableView.endRefreshing()
            self.listeningHistoryTableView.stopLoadingAnimation()
            self.listeningHistoryTableView.finishInfiniteScroll()
        }
        System.endpointRequestQueue.addOperation(historyRequest)
    }
}

// MARK: EmptyStateTableView Delegate

extension ListeningHistoryViewController: EmptyStateTableViewDelegate {
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.selectedIndex = System.discoverSearchTab
    }
}

// MARK: TableView Data Source

extension ListeningHistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListeningHistoryTableViewCellIdentifier") as? ListeningHistoryTableViewCell else { return ListeningHistoryTableViewCell() }
        cell.delegate = self
        cell.configure(for: episodes[indexPath.row])
        return cell
    }

}

// MARK: TableView Delegate

extension ListeningHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episodes[indexPath.row]
        navigationController?.pushViewController(episodeViewController, animated: true)
    }

}


// MARK: ListeningHistoryTableViewCell Delegate

extension ListeningHistoryViewController: ListeningHistoryTableViewCellDelegate {

    func listeningHistoryTableViewCellDidPressMoreButton(cell: ListeningHistoryTableViewCell) {
        guard let indexPath = listeningHistoryTableView.indexPath(for: cell) else { return }
        let episode = episodes[indexPath.row]
        let listeningHistoryOption = ActionSheetOption(type: .listeningHistory, action: {
            let success = {
                self.episodes.remove(at: indexPath.row)
                self.episodeSet.remove(episode)
                self.listeningHistoryTableView.reloadData()
            }
            episode.deleteListeningHistory(success: success)
        })
        let recastOption = ActionSheetOption(type: .recommend(selected: episode.isRecommended), action: { self.recast(for: episode, completion: nil) })
        let bookmarkOption = ActionSheetOption(type: .bookmark(selected: episode.isBookmarked), action: { episode.bookmarkChange() })
        let downloadOption = ActionSheetOption(type: DownloadManager.shared.actionSheetType(for: episode.id), action: {
            DownloadManager.shared.handle(episode)
        })
        let shareEpisodeOption = ActionSheetOption(type: .shareEpisode, action: {
            guard let user = System.currentUser else { return }
            let viewController = ShareEpisodeViewController(user: user, episode: episode)
            self.navigationController?.pushViewController(viewController, animated: true)
        })

        var header: ActionSheetHeader?
        
        if let image = cell.episodeImageView.image, let title = cell.titleLabel.text, let description = cell.detailLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [listeningHistoryOption, recastOption, bookmarkOption, downloadOption, shareEpisodeOption], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }

}
