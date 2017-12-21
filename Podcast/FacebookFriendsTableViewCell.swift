//
//  FacebookFriendsTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/17/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol FacebookFriendsTableViewCellDelegate: class {
    func facebookFriendsTableViewCellDidPressFollowButton(tableViewCell: FacebookFriendsTableViewCell, collectionViewCell: FacebookFriendsCollectionViewCell, user: User)
    func facebookFriendsTableViewCellDidSelectRowAt(tableViewCell: FacebookFriendsTableViewCell, collectionViewCell: FacebookFriendsCollectionViewCell, user: User)
    func facebookFriendsTableViewCellDidPressSeeAllButton(tableViewCell: FacebookFriendsTableViewCell)
}

// This cell is a self sufficent cell that can be inserted in any tableView
// Displays a horizontal collection view of facebook friends to follow
class FacebookFriendsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, FacebookFriendsCollectionViewCellDelegate {

    var collectionView: UICollectionView!
    var headerLabel: UILabel!
    var seeAllButton: UIButton!
    var loadingAnimation: UIActivityIndicatorView!
    var users: [User] = []
    let cellIdentifier = "facebookCollectionViewCell"
    let edgeInsets: CGFloat = 6
    weak var delegate: FacebookFriendsTableViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: FacebookFriendsCollectionViewCell.cellWidth, height: FacebookFriendsCollectionViewCell.cellHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = edgeInsets
        layout.minimumInteritemSpacing = edgeInsets
        layout.sectionInset = UIEdgeInsets(top: 2 * edgeInsets, left: 3 * edgeInsets, bottom: 2 * edgeInsets, right: 3 * edgeInsets)

        headerLabel = UILabel()
        headerLabel.text = "Suggested Facebook Friends"
        headerLabel.font = ._14SemiboldFont()
        headerLabel.textColor = .charcoalGrey

        seeAllButton = UIButton()
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(.slateGrey, for: .normal)
        seeAllButton.titleLabel!.font = ._12RegularFont()
        seeAllButton.titleEdgeInsets.top = 0
        seeAllButton.addTarget(self, action: #selector(didPressSeeAllButton), for: .touchUpInside)

        contentView.addSubview(seeAllButton)
        contentView.addSubview(headerLabel)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(FacebookFriendsCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .clear

        contentView.addSubview(collectionView)

        loadingAnimation = LoadingAnimatorUtilities.createInfiniteScrollAnimator()
        contentView.addSubview(loadingAnimation)

        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2 * edgeInsets)
            make.leading.equalToSuperview().inset(3 * edgeInsets)
        }

        seeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(3 * edgeInsets)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.height.greaterThanOrEqualTo(layout.itemSize.height + 4 * edgeInsets)
            make.leading.trailing.bottom.equalToSuperview()
        }

        loadingAnimation.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6 * edgeInsets)
            make.centerY.equalToSuperview()
        }

        fetchData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fetchData() {
        //TODO: make endpoint to get real data

//        loadingAnimation.startAnimating()
//        let endpointRequest = FetchFacebookFriendsEndpointRequest(pageSize: 20, offset: 0)
//        endpointRequest.success = { request in
//            guard let results = request.processedResponseValue as? [User] else { return }
//            self.users = results
//            self.collectionView.reloadData()
//            self.loadingAnimation.stopAnimating()
//        }
//
//        endpointRequest.failure = { _ in
//            self.loadingAnimation.stopAnimating()
//        }
        users = [System.currentUser!, System.currentUser!, System.currentUser!, System.currentUser!, System.currentUser!, System.currentUser!, System.currentUser!, System.currentUser!, System.currentUser!]
    }

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FacebookFriendsCollectionViewCell else { return FacebookFriendsCollectionViewCell() }
        cell.delegate = self
        cell.configureForUser(user: users[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FacebookFriendsCollectionViewCell else { return }
        delegate?.facebookFriendsTableViewCellDidSelectRowAt(tableViewCell: self, collectionViewCell: cell, user: users[indexPath.row])
    }

    func facebookFriendCollectionViewCellDidPressFollowButton(cell: FacebookFriendsCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        delegate?.facebookFriendsTableViewCellDidPressFollowButton(tableViewCell: self, collectionViewCell: cell, user: users[indexPath.row])
    }

    @objc func didPressSeeAllButton() {
        delegate?.facebookFriendsTableViewCellDidPressSeeAllButton(tableViewCell: self)
    }
}
