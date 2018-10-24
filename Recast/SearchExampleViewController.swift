//
//  SearchViewController.swift
//  Recast
//
//  Created by Drew Dunne on 9/15/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class SearchExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SearchEndpoint(parameters: ["term": "#DORK", "media": "podcast", "limit": 1]).run()
            .success { (response: SearchResults) in
                guard response.resultCount > 0,
                    let partial = response.results.first else { return }
                Podcast.loadFull(from: partial, success: { podcast in
                    print(podcast.title)
                    print(podcast.description)
                    print(podcast.link)
                    print(podcast.collectionName ?? "")
                    print(podcast.items?[1].title ?? "")
                    print(podcast.items?[1].enclosure ?? "")
                    print(podcast.items?[1].iTunes?.duration ?? "")
                }, failure: { error in
                    print(error)
                })
            }
            .failure { (error: Error) in
                print(error)
            }
    }
}
