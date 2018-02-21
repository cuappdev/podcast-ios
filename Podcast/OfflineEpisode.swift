//
//  OfflineEpisode.swift
//  Podcast
//
//  Created by Drew Dunne on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class OfflineEpisode: NSObject {
    
    var isPlaying: Bool = false
    
    var id: String
    var title: String
    var seriesID: String
    var seriesTitle: String
    var dateCreated: Date
    var descriptionText: String = "" {
        didSet {
            let modifiedFont = "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 14\">\(descriptionText)</span>"
            
            if let attrStr = try? NSMutableAttributedString(
                data: modifiedFont.data(using: .utf8, allowLossyConversion: true)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil) {
                // resize hmtl images to fit screen size
                attrStr.enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0), using: { (value, range, stop) in
                    if let attachement = value as? NSTextAttachment {
                        let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                        let screenSize: CGRect = UIScreen.main.bounds
                        if image.size.width > screenSize.width - 36 { // gives buffer of 18 padding on each side
                            let newImage = image.resizeImage(scale: (screenSize.width - 36)/image.size.width)
                            let newAttribut = NSTextAttachment()
                            newAttribut.image = newImage
                            attrStr.addAttribute(NSAttributedStringKey.attachment, value: newAttribut, range: range)
                        }
                    }
                })
                attributedDescription = attrStr
            } else {
                attributedDescription = NSAttributedString(string: "")
            }
        }
    }
    var attributedDescription = NSAttributedString()
    
    var filepath: URL?
    
    init(id: String, title: String, seriesID: String, seriesTitle: String, dateCreated: Date) {
        self.id = id
        self.title = title
        self.seriesID = seriesID
        self.seriesTitle = seriesTitle
        self.dateCreated = dateCreated
    }
    
}
