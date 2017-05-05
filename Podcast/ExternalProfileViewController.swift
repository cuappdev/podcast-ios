//
//  ProfileViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 10/12/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ExternalProfileViewController: ViewController, UITableViewDataSource, UITableViewDelegate, ProfileHeaderViewDelegate, RecommendedSeriesTableViewCellDelegate, RecommendedSeriesTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource {
    
    private var activity: NSMutableArray?
    
    var profileHeaderView: ProfileHeaderView!
    var miniHeader: ProfileMiniHeader!
    var profileTableView: UITableView!
    var backButton: UIButton!
    
    var loadingAnimation: NVActivityIndicatorView!
    
    let headerViewHeight = ProfileHeaderView.height
    let miniBarHeight = ProfileHeaderView.miniBarHeight
    let sectionHeaderHeight: CGFloat = 37
    
    let padding: CGFloat = 12
    let backButtonHeight: CGFloat = 21
    let backButtonWidth: CGFloat = 13
    
    let FooterHeight: CGFloat = 0
    let sectionNames = ["Public Series", "Recommendations"]
    let sectionHeaderHeights: [CGFloat] = [52, 52]
    let sectionContentClasses: [AnyClass] = [RecommendedSeriesTableViewCell.self, RecommendedEpisodesOuterTableViewCell.self]
    let sectionContentIndentifiers = ["SeriesCell", "EpisodesCell"]
    
    var user: User!
    
    var favorites: [Episode]!
    var subscriptions: [GridSeries]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        
        backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: padding, y: ProfileHeaderView.statusBarHeight + (ProfileHeaderView.miniBarHeight - ProfileHeaderView.statusBarHeight - backButtonHeight) / 2, width: backButtonWidth, height: backButtonHeight)
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.adjustsImageWhenHighlighted = true
        backButton.addTarget(self, action: #selector(didPressBackButton), for: .touchUpInside)
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)
        
        loadingAnimation = createLoadingAnimationView()
        loadingAnimation.center = view.center
        view.addSubview(loadingAnimation)
        loadingAnimation.startAnimating()
        UIApplication.shared.statusBarStyle = .default
    }
    
    func createSubviews() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // Instantiate tableView
        profileTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        for (contentClass, identifier) in zip(sectionContentClasses, sectionContentIndentifiers) {
            profileTableView.register(contentClass.self, forCellReuseIdentifier: identifier)
        }
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.backgroundColor = .podcastWhiteDark
        profileTableView.separatorStyle = .none
        profileTableView.showsVerticalScrollIndicator = false
        profileTableView.contentInset.bottom = appDelegate.tabBarController.tabBarHeight
        mainScrollView = profileTableView
        view.addSubview(profileTableView)
        
        let backgroundExtender = UIView(frame: CGRect(x: 0, y: 0-profileTableView.frame.height+20, width: profileTableView.frame.width, height: profileTableView.frame.height))
        backgroundExtender.backgroundColor = .podcastTealBackground
        profileTableView.addSubview(backgroundExtender)
        profileTableView.sendSubview(toBack: backgroundExtender)
        
        // Instantiate tableViewHeader and the minified header
        profileHeaderView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: headerViewHeight))
        miniHeader = ProfileMiniHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: miniBarHeight))
        
        profileTableView.tableHeaderView = profileHeaderView
        profileHeaderView.delegate = self
        
        // Add mini header and back button last (make sure it's on top of hierarchy)
        view.addSubview(miniHeader)
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func fetchUser(id: String) {
        
        let userRequest = FetchUserByIDEndpointRequest(userID: id)
        userRequest.success = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                if let results = endpointRequest.processedResponseValue as? User {
                    self.user = results
                    self.createSubviews()
                    self.updateViewWithUser(results)
                    self.loadingAnimation.stopAnimating()
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            }
        }
        userRequest.failure = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                // Display error
                let alert = UIAlertController(title: "Error Loading User", message: "We couldn't load the specified user, please try again. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                self.loadingAnimation.stopAnimating()
            }
        }
        System.endpointRequestQueue.addOperation(userRequest)
        
        // Now request user subscriptions and favorites
//        let favoritesRequest = GetUserFavoritesEndpointRequest(userID: id)
//        favoritesRequest.success = { (favoritesEndpointRequest: EndpointRequest) in
//            DispatchQueue.main.async {
//                guard let results = favoritesEndpointRequest.processedResponseValue as? [Episode] else { return }
//                self.favorites = results
//                self.profileTableView.reloadData()
//            }
//        }
//        System.endpointRequestQueue.addOperation(favoritesRequest) // UNCOMMENT WHEN FAVORITES ARE DONE
        
        let subscriptionsRequest = FetchUserSubscriptionsEndpointRequest(userID: id)
        subscriptionsRequest.success = { (subscriptionsEndpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                guard let results = subscriptionsEndpointRequest.processedResponseValue as? [GridSeries] else { return }
                self.subscriptions = results
                
                // Need guard in case view hasn't been created
                guard let profileTableView = self.profileTableView else { return }
                profileTableView.reloadData()
            }
        }
        System.endpointRequestQueue.addOperation(subscriptionsRequest)
    }
    
    func updateViewWithUser(_ user: User) {
        self.user = user
        // Update views
        profileHeaderView.setUser(user)
        miniHeader.setUser(user)
        profileTableView.reloadData()
    }
    
    func didPressBackButton() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func followUserHelper(_ profileHeader: ProfileHeaderView) {
        profileHeader.followButton.isEnabled = false // Disable so user cannot send multiple requests
        profileHeader.followButton.setTitleColor(.black, for: .disabled)
        let newFollowRequest = FollowUserEndpointRequest(userID: user.id)
        newFollowRequest.success = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                // Follow succeded
                profileHeader.followButton.isEnabled = true
                profileHeader.followButton.isSelected = true
                self.user.isFollowing = true
            }
        }
        newFollowRequest.failure = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                // Follow failed
                profileHeader.followButton.isEnabled = true
                profileHeader.followButton.isSelected = false
                self.user.isFollowing = false
            }
        }
        System.endpointRequestQueue.addOperation(newFollowRequest)
    }
    
    func unfollowUserHelper(_ profileHeader: ProfileHeaderView) {
        profileHeader.followButton.isEnabled = false // Disable so user cannot send multiple requests
        profileHeader.followButton.setTitleColor(.podcastWhite, for: .disabled)
        let unfollowRequest = UnfollowUserEndpointRequest(userID: user.id)
        unfollowRequest.success = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                // Unfollow succeded
                profileHeader.followButton.isEnabled = true
                profileHeader.followButton.isSelected = false
                self.user.isFollowing = false
            }
        }
        unfollowRequest.failure = { (endpointRequest: EndpointRequest) in
            DispatchQueue.main.async {
                // Unfollow failed
                profileHeader.followButton.isEnabled = true
                profileHeader.followButton.isSelected = true
                self.user.isFollowing = true
            }
        }
        System.endpointRequestQueue.addOperation(unfollowRequest)
    }
    
    // Mark: - ProfileHeaderView
    func profileHeaderDidPressFollowButton(profileHeader: ProfileHeaderView, follow: Bool) {
        // Follow/Unfollow someone
        if follow {
            followUserHelper(profileHeader)
        } else {
            unfollowUserHelper(profileHeader)
        }
    }
    
    func profileHeaderDidPressFollowers(profileHeader: ProfileHeaderView) {
        // Move to view of followers list
    }
    
    func profileHeaderDidPressFollowing(profileHeader: ProfileHeaderView) {
        // Move to view of following list
    }
    
    func profileHeaderDidPressMoreButton(profileHeader: ProfileHeaderView) {
        // Bring up more button action sheet
    }
    
    // MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // don't know how to condense this using an array like the other functions
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionContentIndentifiers[indexPath.section]) else { return UITableViewCell() }
        if let cell = cell as? RecommendedSeriesTableViewCell {
            cell.dataSource = self
            cell.delegate = self
            cell.backgroundColor = .podcastWhiteDark
            cell.reloadCollectionViewData()
        } else if let cell = cell as? RecommendedEpisodesOuterTableViewCell {
            cell.dataSource = self
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return FooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeights[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ProfileSectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeights[section]))
        header.setSectionText(sectionName: sectionNames[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            guard let favoriteEpisodes = favorites else { return 0 }
            return CGFloat(favoriteEpisodes.count) * EpisodeTableViewCell.height
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        profileHeaderView.animateByYOffset(scrollView.contentOffset.y)
        let yOffset = scrollView.contentOffset.y
        let aboveThreshold = (yOffset > 109)
        miniHeader.setMiniHeaderState(aboveThreshold)
        let showsShadow = (yOffset > ProfileHeaderView.profileAreaHeight - ProfileHeaderView.miniBarHeight)
        miniHeader.setMiniHeaderShadowState(showsShadow)
    }
    
    // MARK: - RecommendedSeriesTableViewCell DataSource & Delegate
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, dataForItemAt indexPath: IndexPath) -> GridSeries {
        guard let subscriptions = subscriptions else { return GridSeries() }
        return subscriptions[indexPath.row]
    }
    
    func numberOfRecommendedSeries(forRecommendedSeriesTableViewCell cell: RecommendedSeriesTableViewCell) -> Int {
        guard let subscriptions = subscriptions else { return 0 }
        return subscriptions.count
    }
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, didSelectItemAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController()
        guard let subscriptions = subscriptions else { return }
        let series = subscriptions[indexPath.row]
        seriesDetailViewController.fetchAndSetSeries(seriesID: series.seriesId)
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
    
    // MARK: - RecommendedEpisodesOuterTableViewCell DataSource & Delegate
    
    func recommendedEpisodesTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, dataForItemAt indexPath: IndexPath) -> Episode {
        guard let favoriteEpisodes = favorites else { return Episode() }
        return favoriteEpisodes[indexPath.row]
    }
    
    func numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell cell: RecommendedEpisodesOuterTableViewCell) -> Int {
        return 0
        // UNCOMMENT when favorites are done
//        guard let favoriteEpisodes = favorites else { return 0 }
//        return favoriteEpisodes.count
    }
    
    func recommendedEpisodesOuterTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, didSelectItemAt indexPath: IndexPath) {
        print("Selected episode at \(indexPath.row)")
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressPlayButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        if !episode.isBookmarked {
            let endpointRequest = CreateBookmarkEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isBookmarked = true
                episodeTableViewCell.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteBookmarkEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isBookmarked = true
                episodeTableViewCell.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        if !episode.isRecommended {
            let endpointRequest = CreateRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = true
                episodeTableViewCell.setRecommendedButtonToState(isRecommended: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = false
                episodeTableViewCell.setRecommendedButtonToState(isRecommended: false)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    func recommendedEpisodesOuterTableViewCellDidPressShowActionSheet(episodeTableViewCell: EpisodeTableViewCell) {
        let option1 = ActionSheetOption(title: "Download", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "shareButton")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let option3 = ActionSheetOption(title: "Go to Series", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        
        var header: ActionSheetHeader?
        
        if let image = episodeTableViewCell.podcastImage.image, let title = episodeTableViewCell.episodeNameLabel.text, let description = episodeTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    
    func recommendedEpisodesOuterTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode, index: Int) {
        let tagViewController = TagViewController()
        tagViewController.tag = episode.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }

}
