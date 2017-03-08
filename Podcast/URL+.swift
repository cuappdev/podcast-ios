//
//  URL+.swift
//  Podcast
//
//  Created by Kevin Greer on 3/8/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

extension URL {
    func getImage() -> UIImage? {
        if let data = try? Data(contentsOf: self) {
            return UIImage(data: data)
        }
        return #imageLiteral(resourceName: "sample_series_artwork")
    }
}

func getImage(fromOptional url: URL?) -> UIImage? {
    if let url = url {
        return url.getImage()
    } else {
        return #imageLiteral(resourceName: "sample_series_artwork")
    }
}
