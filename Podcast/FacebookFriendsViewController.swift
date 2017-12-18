//
//  FacebookFriendsViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/17/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FacebookFriendsViewController: ViewController, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, SearchPeopleTableViewCellDelegate, SearchHeaderDelegate {

    var searchController: UISearchController!
    var tableView: EmptyStateTableView!
    var searchHeaderView: SearchHeaderView?
    var searchResults: [User] = []
    let userCellIdentifier: String = "SearchPeopleTableViewCellIdentifier"
    var continueInfiniteScroll: Bool = true
    var offset: Int = 0
    var pageSize: Int = 20

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

        tableView.addInfiniteScroll { _ -> Void in
            self.fetchData()
        }

        //tells the infinite scroll when to stop
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }

        tableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()

        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar

        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = .offWhite
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.showsSearchResultsButton = false
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        definesPresentationContext = true

        searchHeaderView = SearchHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: searchHeaderViewHeight), type: .facebook)
        searchHeaderView?.delegate = self
        tableView.tableHeaderView = searchHeaderView

        searchHeaderView?.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(searchHeaderViewHeight).priority(999)
        }

        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentUser = System.currentUser, !currentUser.isFacebookUser {
            tableView.tableHeaderView = searchHeaderView
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        fetchData()
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

    func fetchData() {
        searchResults = [] 
        tableView.reloadData()
        tableView.startLoadingAnimation()
        tableView.backgroundView?.isHidden = false
        // Fake data
        let endpointRequest = FetchFacebookFriendsEndpointRequest(pageSize: pageSize, offset: offset)
        endpointRequest.success = { request in
            guard let users = request.processedResponseValue as? [User] else { return }
            self.searchResults = users
            self.tableView.stopLoadingAnimation()
            self.tableView.reloadData()
        }
        endpointRequest.failure = { _ in
            self.tableView.stopLoadingAnimation()
            print("failure")
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    // MARK: UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        // here
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
        Authentication.sharedInstance.signInWithFacebook(viewController: self, success: {
            Authentication.sharedInstance.mergeAccounts(signInTypeToMergeIn: .Facebook, success: { _,_,_ in
                self.fetchData()
            }, failure: {
                self.fetchData()
            })
        })
    }

    func searchHeaderDidPressDismiss(searchHeader: SearchHeaderView) {
        tableView.tableHeaderView = nil
    }
}
