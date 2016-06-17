//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/15/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class Gif: NSObject, NSCoding {

    var url: NSURL?
    var videoURL: NSURL?
    var caption: String?
    var gifImage: UIImage?
    var gifData: NSData?
    
    init(GifUrl url:NSURL, videoURL:NSURL, caption:String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gifWithURL(url.absoluteString)
        self.gifData = nil
    }
    
    init(name:String) {
        self.gifImage = UIImage.gifWithName(name)
    }
    
    // MARK: - NSCoding Protocol
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        // Unarchive the data, one property at a time
        self.url = aDecoder.decodeObjectForKey("url") as? NSURL
        self.caption = aDecoder.decodeObjectForKey("caption") as? String
        self.videoURL = aDecoder.decodeObjectForKey("videoURL") as? NSURL
        self.gifImage = aDecoder.decodeObjectForKey("gifImage") as? UIImage
        self.gifData = aDecoder.decodeObjectForKey("gifData") as? NSData
    }
    
    // Encode object
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.caption, forKey: "caption")
        aCoder.encodeObject(self.videoURL, forKey: "videoURL")
        aCoder.encodeObject(self.gifImage, forKey: "gifImage")
        aCoder.encodeObject(self.gifData, forKey: "gifData")
    }
    
}
