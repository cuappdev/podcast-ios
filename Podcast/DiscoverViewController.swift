//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate {

    var feedTableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = UIColor.podcastGrayLight
        
        feedTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        feedTableView.delegate = self
        feedTableView.backgroundColor = UIColor.podcastGrayLight
        feedTableView.registerClass(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCellIdentifier")
        
        view.addSubview(feedTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverTableViewCellIdentifier") as! DiscoverTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
