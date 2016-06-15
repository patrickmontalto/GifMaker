//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/15/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class Gif {

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
    
}
