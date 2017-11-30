//
//  UIImage+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)

        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
