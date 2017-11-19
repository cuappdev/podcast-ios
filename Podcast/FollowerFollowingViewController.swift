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

class FollowerFollowingViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SearchPeopleTableViewCellDelegate, EmptyStateTableViewDelegate {
    
    let cellIdentifier = "searchUsersCell"
    
    var usersTableView: EmptyStateTableView!
    
    var users: [User] = []
    var currentViewUser: User
    var followersOrFollowings: UserFollowsType!
    
    init(user: User) {
        currentViewUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = followersOrFollowings == .Followers ? "Followers" : "Following"

        // Do any additional setup after loading the view.
        usersTableView = EmptyStateTableView(frame: view.frame, type: followersOrFollowings == .Followers ? .followers : .following, isRefreshable: true)
        usersTableView.emptyStateTableViewDelegate = self
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.backgroundColor = .clear
        usersTableView.register(SearchPeopleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        usersTableView.reloadData()
        mainScrollView = usersTableView
        view.addSubview(usersTableView)
        
        usersTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usersTableView.reloadData()
    }
    
    func emptyStateTableViewHandleRefresh() {
        fetchUsers()
    }

    func didPressEmptyStateViewActionItem() {
        // delegate protocol
    }

    
    func fetchUsers() {
        let endpointRequest = FetchUserFollowsByIDRequest(userId: currentViewUser.id, type: followersOrFollowings)
        endpointRequest.success = { request in
            guard let follows = request.processedResponseValue as? [User] else { return }
            self.users = follows
            self.usersTableView.endRefreshing()
            self.usersTableView.stopLoadingAnimation()
            self.usersTableView.reloadSections([0] , with: .automatic)
        }
        
        endpointRequest.failure = { _ in
            self.usersTableView.endRefreshing()
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
        let profileViewController = ExternalProfileViewController(user: user)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else {
            let cell = SearchPeopleTableViewCell()
            cell.configure(for: users[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        }
        cell.configure(for: users[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchPeopleTableViewCell.cellHeight
    }
    
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let indexPath = usersTableView.indexPath(for: cell) else { return }
        let user = users[indexPath.row]
        user.followChange(completion: cell.setFollowButtonState)
    }

}
