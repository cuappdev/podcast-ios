//
//  ListeningHistoryViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/24/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class ListeningHistoryViewController: ViewController, UITableViewDelegate, UITableViewDataSource, ListeningHistoryTableViewCellDelegate {
    
    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    ///
    /// Mark: Variables
    ///
    var listeningHistoryTableView: UITableView!
    var episodes: [Episode] = []
    var episodeSet = Set<Episode>()
    var refreshControl: UIRefreshControl!
    
    let pageSize: Int = 20
    var offset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        title = "Listening History"
        
        //tableview
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        listeningHistoryTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        listeningHistoryTableView.delegate = self
        listeningHistoryTableView.dataSource = self
        listeningHistoryTableView.backgroundColor = .clear
        listeningHistoryTableView.separatorStyle = .none 
        listeningHistoryTableView.showsVerticalScrollIndicator = false
        listeningHistoryTableView.contentInset = UIEdgeInsetsMake(0, 0, appDelegate.tabBarController.tabBarHeight, 0)
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
        refreshControl.tintColor = .podcastTeal
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        listeningHistoryTableView.addSubview(refreshControl)
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
        let option1 = ActionSheetOption(title: "Remove from Listening History", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Download", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "shareButton")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let option4 = ActionSheetOption(title: "Go to Series", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
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
    
    func handleRefresh() {
        fetchEpisodes(refresh: true)
    }
    
    func fetchEpisodes(refresh: Bool) {
        if refresh {
            offset = 0
        }
        let historyRequest = FetchListeningHistoryEndpointRequest(offset: offset, max: pageSize)
        historyRequest.success = { request in
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
            if refresh {
                self.refreshControl.endRefreshing()
            } else {
                self.listeningHistoryTableView.finishInfiniteScroll()
            }
        }
        System.endpointRequestQueue.addOperation(historyRequest)
    }
}
