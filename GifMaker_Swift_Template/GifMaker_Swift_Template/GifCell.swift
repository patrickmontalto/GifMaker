//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/17/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet var gifImageView: UIImageView!
    
    func configureForGif(gif: Gif) {
        gifImageView.image = gif.gifImage
    }
}
