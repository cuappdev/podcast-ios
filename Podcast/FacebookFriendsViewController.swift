//
//  FacebookFriendsViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/17/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FacebookFriendsViewController: ViewController, GIDSignInUIDelegate {

    var searchController: UISearchController!
    var tableView: EmptyStateTableView!
    var searchHeaderView: SearchHeaderView?
    var searchResults: [User] = []
    let userCellIdentifier: String = "SearchPeopleTableViewCellIdentifier"
    var continueInfiniteScroll: Bool = true
    var pageSize: Int = 20
    var query: String?

    let searchHeaderViewHeight: CGFloat = 79.5

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find Friends"
        view.backgroundColor = .paleGrey

        tableView = EmptyStateTableView(frame: .zero, type: .search)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView?.isHidden = true
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainScrollView = tableView

        tableView.addInfiniteScroll { _ in
            self.fetchData(searchText: self.query, infiniteScroll: true)
        }

        //tells the infinite scroll when to stop
        tableView.setShouldShowInfiniteScrollHandler { _ in
            return self.continueInfiniteScroll
        }

        tableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()

        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController

        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = .offWhite
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.showsSearchResultsButton = false
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        definesPresentationContext = true

        if let user = System.currentUser, user.isFacebookUser && Authentication.sharedInstance.facebookAccessToken == nil {
            searchHeaderView = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: searchHeaderViewHeight), type: .facebookRelogin)
        } else {
            searchHeaderView = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: searchHeaderViewHeight), type: .facebook)
        }
        searchHeaderView?.delegate = self
        tableView.tableHeaderView = searchHeaderView

        searchHeaderView?.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(searchHeaderViewHeight).priority(999)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Authentication.sharedInstance.setDelegate(self)
        if let currentUser = System.currentUser, !currentUser.isFacebookUser || Authentication.sharedInstance.facebookAccessToken == nil {
            tableView.tableHeaderView = searchHeaderView
        } else {
            tableView.tableHeaderView = nil
            fetchData(searchText: query)
        }
    }

    func fetchData(searchText: String?, infiniteScroll: Bool = false) {
        guard let facebookAccessToken = Authentication.sharedInstance.facebookAccessToken else { return }

        let endpointRequest: EndpointRequest
        if let query = searchText {
            endpointRequest = SearchFacebookFriendsEndpointRequest(facebookAccessToken: facebookAccessToken, query: query, offset: infiniteScroll ? searchResults.count : 0, max: pageSize)
        } else {
            endpointRequest = FetchFacebookFriendsEndpointRequest(facebookAccessToken: facebookAccessToken, pageSize: pageSize, offset: infiniteScroll ? searchResults.count : 0, returnFollowing: true)
        }

        let prevResults = searchResults
        if !infiniteScroll {
            searchResults = []
            tableView.reloadData()
            tableView.startLoadingAnimation()
            tableView.backgroundView?.isHidden = false
            self.continueInfiniteScroll = true
        }

        endpointRequest.success = { request in
            guard let users = request.processedResponseValue as? [User] else { return }
            self.searchResults = infiniteScroll ? prevResults + users : users
            if users.count < self.pageSize { self.continueInfiniteScroll = false }
            self.tableView.finishInfiniteScroll()
            self.tableView.stopLoadingAnimation()
            self.tableView.reloadData()
        }

        endpointRequest.failure = { _ in
            self.tableView.stopLoadingAnimation()
            print("failure")
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

}

// MARK: TableView Data Source
extension FacebookFriendsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchPeopleTableViewCell.cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchPeopleTableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier) as? SearchPeopleTableViewCell {
            cell = dequeuedCell
        } else {
            cell = SearchPeopleTableViewCell(style: .default, reuseIdentifier: userCellIdentifier)
        }
        cell.configure(for: searchResults[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

}

// MARK: TableView Delegate
extension FacebookFriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let externalProfileViewController = UserDetailViewController(user: searchResults[indexPath.row])
        navigationController?.pushViewController(externalProfileViewController,animated: true)
    }
}

// MARK: Search Controller Delegate
extension FacebookFriendsViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: Search Bar Delegate
extension FacebookFriendsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        query = searchText
        fetchData(searchText: query)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }

}

// MARK: SearchPeopleTableViewCell Delegate
extension FacebookFriendsViewController: SearchPeopleTableViewCellDelegate {
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let user = searchResults[indexPath.row]
        user.followChange(completion: cell.setFollowButtonState)
    }
}

// MARK: Search Header Delegate
extension FacebookFriendsViewController: SearchHeaderDelegate {
    func searchHeaderDidPress(searchHeader: SearchHeaderView) {
        Authentication.sharedInstance.signIn(with: .Facebook, viewController: self)
    }

    func searchHeaderDidPressDismiss(searchHeader: SearchHeaderView) {
        tableView.tableHeaderView = nil
    }
}

// MARK: Sign In UI Delegate
extension FacebookFriendsViewController: SignInUIDelegate {
    func signedIn(for type: SignInType, withResult result: SignInResult) {
        let completion = { self.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil) }
        let success = {
            self.fetchData(searchText: nil)
            self.tableView.tableHeaderView = nil
        }

        switch result {
        case .success:
            guard let user = System.currentUser else { return }
            if user.isFacebookUser {
                Authentication.sharedInstance.authenticateUser(signInType: .Facebook, success: { _ in success() }, failure: completion)
            } else {
                Authentication.sharedInstance.mergeAccounts(signInTypeToMergeIn: .Facebook, success: { _ in success() }, failure: completion)
            }
        case .cancelled:
            break
        case .failure:
            completion()
        }
    }
}
