//
//  FollowerFollowingViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 9/10/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

/**
 * This view controller is for both displaying your followers and whom you follow.
 */

import UIKit
import NVActivityIndicatorView

class FollowerFollowingViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "searchUsersCell"
    
    var usersTableView: UITableView!
    var loadingActivityIndicator: NVActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    var users: [User] = []
    var followersOrFollowings: UserFollowsType!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = followersOrFollowings == .Followers ? "Followers" : "Following"

        // Do any additional setup after loading the view.
        usersTableView = UITableView(frame: CGRect.zero)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.backgroundColor = .clear
        usersTableView.separatorStyle = .none
        usersTableView.showsVerticalScrollIndicator = false
        usersTableView.register(SearchPeopleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        usersTableView.reloadData()
        mainScrollView = usersTableView
        view.addSubview(usersTableView)
        
        loadingActivityIndicator = createLoadingAnimationView()
        loadingActivityIndicator.center = view.center
        view.addSubview(loadingActivityIndicator)
        loadingActivityIndicator.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sea
        refreshControl.addTarget(self, action: #selector(FollowerFollowingViewController.handleRefresh), for: UIControlEvents.valueChanged)
        usersTableView.addSubview(refreshControl)
        
        usersTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fetchUsers()
    }
    
    @objc func handleRefresh() {
        fetchUsers()
    }
    
    func fetchUsers() {
        let endpointRequest = FetchUserFollowsByIDRequest(userId: System.currentUser!.id, type: followersOrFollowings)
        endpointRequest.success = { request in
            guard let follows = request.processedResponseValue as? [User] else { return }
            self.users = follows
            self.refreshControl.endRefreshing()
            self.loadingActivityIndicator.stopAnimating()
            self.usersTableView.reloadSections([0] , with: .automatic)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    //
    // MARK: TableView Delegate & DataSource Methods
    //

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Bring up user profile
        let user = users[indexPath.row]
        let profileViewController = ExternalProfileViewController()
        profileViewController.setUser(user: user)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else {
            let cell = SearchPeopleTableViewCell()
            cell.configure(for: users[indexPath.row], index: indexPath.row)
            return cell
        }
        cell.configure(for: users[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchPeopleTableViewCell.cellHeight
    }

}
