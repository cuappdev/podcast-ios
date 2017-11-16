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
    var continueInfiniteScroll: Bool = true
    let pageSize: Int = 20
    var offset: Int = 0
    
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
    
        listeningHistoryTableView.refreshControl?.addTarget(self, action: #selector(fetchEpisodes), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.isHeroEnabled = true
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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

    func reloadTableView() {
        listeningHistoryTableView.reloadSections(IndexSet(integer: 0), with: .fade)
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
                self.reloadTableView()
            }
            episode.deleteListeningHistory(success: success)
        })
        let option2 = ActionSheetOption(type: .recommend(selected: episode.isRecommended), action: { episode.recommendedChange() })
        let option3 = ActionSheetOption(type: .bookmark(selected: episode.isBookmarked), action: { episode.bookmarkChange() })
        let option4 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        var header: ActionSheetHeader?
        
        if let image = cell.episodeImageView.image, let title = cell.titleLabel.text, let description = cell.detailLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3, option4], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK

    @objc func fetchEpisodes(refresh: Bool = true) {
        if refresh {
            offset = 0
        }
        let historyRequest = FetchListeningHistoryEndpointRequest(offset: offset, max: pageSize)
        historyRequest.success = { request in
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            let oldCount = self.episodeSet.count
            for episode in newEpisodes {
                self.episodeSet.insert(episode)
            }
            if oldCount == self.episodeSet.count { self.continueInfiniteScroll = false }
            self.episodes = self.episodeSet.sorted { (e1,e2) in e1.dateCreated > e2.dateCreated } //TODO: order these by listening history creation
            self.listeningHistoryTableView.endRefreshing()
            self.listeningHistoryTableView.stopLoadingAnimation()
            self.listeningHistoryTableView.finishInfiniteScroll()
            self.reloadTableView()
        }

        historyRequest.failure = { _ in
            self.listeningHistoryTableView.endRefreshing()
            self.listeningHistoryTableView.stopLoadingAnimation()
            self.listeningHistoryTableView.finishInfiniteScroll()
        }
        System.endpointRequestQueue.addOperation(historyRequest)
    }
    
    //MARK:
    //MARK: - Empty state view delegate
    //MARK:
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.discoverTab) 
    }
}
