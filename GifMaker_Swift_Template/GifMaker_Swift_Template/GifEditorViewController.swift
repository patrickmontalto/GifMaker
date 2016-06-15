//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/15/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {
    
    @IBOutlet var gifImageView: UIImageView!
    var gifURL: NSURL?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let gifURL = gifURL {
            let gif = UIImage.gifWithURL(gifURL.absoluteString)
            gifImageView.image = gif
        }
    }
}
