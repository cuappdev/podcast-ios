//
//  ListeningHistoryViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/24/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class ListeningHistoryViewController: ViewController, UITableViewDelegate, UITableViewDataSource, ListeningHistoryTableViewCellDelegate, EmptyStateTableViewDelegate {
    
    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    ///
    /// Mark: Variables
    ///
    var listeningHistoryTableView: EmptyStateTableView! //not a delegate because no action button
    var episodes: [Episode] = []
    var episodeSet = Set<Episode>()
    var refreshControl: UIRefreshControl!
    
    let pageSize: Int = 20
    var offset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Listening History"
        
        //tableview
        listeningHistoryTableView = EmptyStateTableView(frame: view.frame, type: .listeningHistory)
        listeningHistoryTableView.delegate = self
        listeningHistoryTableView.dataSource = self
        listeningHistoryTableView.emptyStateTableViewDelegate = self
        listeningHistoryTableView.register(ListeningHistoryTableViewCell.self, forCellReuseIdentifier: "ListeningHistoryTableViewCellIdentifier")
        view.addSubview(listeningHistoryTableView)
        listeningHistoryTableView.rowHeight = ListeningHistoryTableViewCell.height
        listeningHistoryTableView.reloadData()
        mainScrollView = listeningHistoryTableView
        
        listeningHistoryTableView.infiniteScrollIndicatorView = createLoadingAnimationView()
        listeningHistoryTableView.addInfiniteScroll { tableView in
            self.fetchEpisodes(refresh: false)
        }
        self.fetchEpisodes(refresh: true)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sea
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        listeningHistoryTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listeningHistoryTableView.reloadData()
    }
    
    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListeningHistoryTableViewCellIdentifier") as? ListeningHistoryTableViewCell else { return ListeningHistoryTableViewCell() }
        cell.delegate = self
        cell.configure(for: episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episodes[indexPath.row]
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    
    //MARK: -
    //MARK: ListeningHistoryTableViewCell Delegate
    //MARK: -
    
    func listeningHistoryTableViewCellDidPressMoreButton(cell: ListeningHistoryTableViewCell) {
        guard let indexPath = listeningHistoryTableView.indexPath(for: cell) else { return }
        let episode = episodes[indexPath.row]
        let option1 = ActionSheetOption(type: .listeningHistory, action: {
            let success = {
                self.episodes.remove(at: indexPath.row)
                self.episodeSet.remove(episode)
                self.listeningHistoryTableView.reloadData()
            }
            episode.deleteListeningHistory(success: success)
        })
        let option2 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        var header: ActionSheetHeader?
        
        if let image = cell.episodeImageView.image, let title = cell.titleLabel.text, let description = cell.detailLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    
    @objc func handleRefresh() {
        fetchEpisodes(refresh: true)
    }
    
    func fetchEpisodes(refresh: Bool) {
        if refresh {
            offset = 0
        }
        let historyRequest = FetchListeningHistoryEndpointRequest(offset: offset, max: pageSize)
        historyRequest.success = { request in
            self.listeningHistoryTableView.stopLoadingAnimation()
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            self.offset = self.offset + newEpisodes.count
            if refresh {
                self.episodeSet.removeAll()
                for episode in newEpisodes {
                    self.episodeSet.insert(episode)
                }
                self.episodes = self.episodeSet.sorted(by: { lhs, rhs in lhs.dateCreated < rhs.dateCreated } )
                self.listeningHistoryTableView.reloadSections([0] , with: .automatic)
                self.refreshControl.endRefreshing()
            } else {
                let oldCount = self.episodes.count
                for episode in newEpisodes {
                    self.episodeSet.insert(episode)
                }
                self.episodes = self.episodeSet.sorted(by: { lhs, rhs in lhs.dateCreated < rhs.dateCreated } )
                let indexPaths = (oldCount..<self.episodes.count).map { return IndexPath(row: $0, section: 0) }
                self.listeningHistoryTableView.beginUpdates()
                self.listeningHistoryTableView.insertRows(at: indexPaths, with: .automatic)
                self.listeningHistoryTableView.endUpdates()
                self.listeningHistoryTableView.finishInfiniteScroll()
            }
        }
        historyRequest.failure = { _ in
            self.listeningHistoryTableView.stopLoadingAnimation()
            if refresh {
                self.refreshControl.endRefreshing()
            } else {
                self.listeningHistoryTableView.finishInfiniteScroll()
            }
        }
        System.endpointRequestQueue.addOperation(historyRequest)
    }
    
    //MARK:
    //MARK: - Empty state view delegate
    //MARK:
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.searchTab) 
    }
}
