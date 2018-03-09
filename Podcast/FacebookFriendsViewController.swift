//
//  FacebookFriendsViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/17/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FacebookFriendsViewController: ViewController, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, SearchPeopleTableViewCellDelegate, SearchHeaderDelegate, SignInUIDelegate, GIDSignInUIDelegate {

    var searchController: UISearchController!
    var tableView: EmptyStateTableView!
    var searchHeaderView: SearchHeaderView?
    var searchResults: [User] = []
    let userCellIdentifier: String = "SearchPeopleTableViewCellIdentifier"
    var continueInfiniteScroll: Bool = true
    var offset: Int = 0
    var pageSize: Int = 20
    var query: String?

    let searchHeaderViewHeight: CGFloat = 79.5

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Connect with Facebook Friends"
        view.backgroundColor = .paleGrey

        tableView = EmptyStateTableView(frame: view.frame, type: .search)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView?.isHidden = true
        view.addSubview(tableView)
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
        tableView.tableHeaderView = searchController.searchBar

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

        fetchData(searchText: query)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Authentication.sharedInstance.setDelegate(self)
        if let currentUser = System.currentUser, !currentUser.isFacebookUser || Authentication.sharedInstance.facebookAccessToken == nil {
            tableView.tableHeaderView = searchHeaderView
        } else {
            tableView.tableHeaderView = searchController.searchBar
            fetchData(searchText: query)
        }
    }

    // MARK: TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let externalProfileViewController = ExternalProfileViewController(user: searchResults[indexPath.row])
        navigationController?.pushViewController(externalProfileViewController,animated: true)
    }

    func fetchData(searchText: String?, infiniteScroll: Bool = false) {
        guard let facebookAccessToken = Authentication.sharedInstance.facebookAccessToken else { return }
        let prevResults = searchResults
        searchResults = []
        tableView.reloadData()
        tableView.startLoadingAnimation()
        tableView.backgroundView?.isHidden = false

        let endpointRequest: EndpointRequest
        if let query = searchText {
            endpointRequest = SearchFacebookFriendsEndpointRequest(facebookAccessToken: facebookAccessToken, query: query, offset: infiniteScroll ? offset : 0, max: pageSize)
        } else {
             endpointRequest = FetchFacebookFriendsEndpointRequest(facebookAccessToken: facebookAccessToken, pageSize: pageSize, offset: infiniteScroll ? offset : 0)
        }

        endpointRequest.success = { request in
            guard let users = request.processedResponseValue as? [User] else { return }
            self.offset = infiniteScroll ? self.offset + self.pageSize : 0
            self.searchResults = infiniteScroll ? prevResults + users : users
            self.continueInfiniteScroll = users.count >= self.pageSize
            self.tableView.stopLoadingAnimation()
            self.tableView.reloadData()
        }

        endpointRequest.failure = { _ in
            self.offset = infiniteScroll ? self.offset : 0
            self.tableView.stopLoadingAnimation()
            print("failure")
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    // MARK: UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        query = searchText
        fetchData(searchText: query)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: SearchPeopleTableViewCellDelegate

    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let user = searchResults[indexPath.row]
        user.followChange(completion: cell.setFollowButtonState)
    }

    // MARK: SearchHeaderDelegate

    func searchHeaderDidPress(searchHeader: SearchHeaderView) {
        Authentication.sharedInstance.signIn(with: .Facebook, viewController: self)
    }

    func searchHeaderDidPressDismiss(searchHeader: SearchHeaderView) {
        tableView.tableHeaderView = nil
    }

    func signedIn(for type: SignInType, withResult result: SignInResult) {
        let completion = { self.present(UIAlertController.somethingWentWrongAlert(), animated: true, completion: nil) }
        let success = {
            self.fetchData(searchText: nil)
            self.tableView.tableHeaderView = self.searchController.searchBar
        }

        switch(result) {
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
