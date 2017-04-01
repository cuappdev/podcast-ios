//
//  ProfileViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 10/12/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class ExternalProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileHeaderViewDelegate, RecommendedSeriesTableViewCellDelegate, RecommendedSeriesTableViewCellDataSource, RecommendedEpisodesOuterTableViewCellDelegate, RecommendedEpisodesOuterTableViewCellDataSource {
    
    private var activity: NSMutableArray?
    
    var profileHeaderView: ProfileHeaderView!
    var miniHeader: ProfileMiniHeader!
    var profileTableView: UITableView!
    var backButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        fetchUser(id: 0)
    }
    
    func createSubviews() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        view.backgroundColor = .podcastWhiteDark
        
        backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: padding, y: ProfileHeaderView.statusBarHeight + (ProfileHeaderView.miniBarHeight - ProfileHeaderView.statusBarHeight - backButtonHeight) / 2, width: backButtonWidth, height: backButtonHeight)
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.adjustsImageWhenHighlighted = true
        backButton.addTarget(self, action: #selector(didPressBackButton), for: .touchUpInside)
        
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
        profileTableView.contentInset = UIEdgeInsetsMake(0, 0, appDelegate.tabBarController.tabBarHeight, 0)
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
    
    func fetchUser(id: Int) {
        
        // Dummy data
        let user = User()
        user.firstName = "Paul"
        user.lastName = "Dugg"
        user.username = "doglover12"
        user.numberOfFollowing = 100
        user.numberOfFollowers = 4
        
        let s = Series()
        s.title = "Design Details"
        s.numberOfSubscribers = 832567
        user.subscriptions = Array(repeating: s, count: 7)
        
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.seriesId = 0
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.tags = [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")]
        user.favoriteEpisodes = Array(repeating: episode, count: 5)
        
        updateViewWithUser(user)
    }
    
    func updateViewWithUser(_ user: User) {
        self.user = user
        // Update views
        profileHeaderView.setUser(user)
        miniHeader.setUser(user)
        profileTableView.reloadData()
    }
    
    func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // Mark: - ProfileHeaderView
    func profileHeaderDidPressFollowButton(profileHeader: ProfileHeaderView, follow: Bool) {
        // Follow/Unfollow someone
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
            guard let user = user else { return 0 }
            return CGFloat(user.favoriteEpisodes.count) * EpisodeTableViewCell.height
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
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, dataForItemAt indexPath: IndexPath) -> Series {
        return user.subscriptions[indexPath.row]
    }
    
    func numberOfRecommendedSeries(forRecommendedSeriesTableViewCell cell: RecommendedSeriesTableViewCell) -> Int {
        return user.subscriptions.count
    }
    
    func recommendedSeriesTableViewCell(cell: RecommendedSeriesTableViewCell, didSelectItemAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController()
        seriesDetailViewController.series = user.subscriptions[indexPath.row]
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
    
    // MARK: - RecommendedEpisodesOuterTableViewCell DataSource & Delegate
    
    func recommendedEpisodesTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, dataForItemAt indexPath: IndexPath) -> Episode {
        return user.favoriteEpisodes[indexPath.row]
    }
    
    func numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell cell: RecommendedEpisodesOuterTableViewCell) -> Int {
        return user.favoriteEpisodes.count
    }
    
    func recommendedEpisodesOuterTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, didSelectItemAt indexPath: IndexPath) {
        print("Selected episode at \(indexPath.row)")
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressPlayButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        episode.isBookmarked = !episode.isBookmarked
        episodeTableViewCell.setBookmarkButtonToState(isBookmarked: episode.isBookmarked)
    }
    
    func recommendedEpisodeOuterTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode) {
        episode.isRecommended = !episode.isRecommended
        episodeTableViewCell.setRecommendedButtonToState(isRecommended: episode.isRecommended)
    }
    
    func recommendedEpisodesOuterTableViewCellDidPressShowActionSheet(episodeTableViewCell: EpisodeTableViewCell) {
        let option1 = ActionSheetOption(title: "Download", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "shareButton"), action: nil)
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
