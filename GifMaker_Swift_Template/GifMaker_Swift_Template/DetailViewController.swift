//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/17/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var gif: Gif?
    @IBOutlet var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set GIF Image
        if let gif = gif {
            gifImageView.image = gif.gifImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func closeDetailView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareGif(sender: UIButton) {
        if let gif = gif, gifData = gif.gifData {
            var itemsToShare = [NSData]()
            itemsToShare.append(gifData)
            
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            
            // Set activityVC to dismiss when completed
            activityVC.completionWithItemsHandler = {
                (activity, completed, items, error) in
                if (completed) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            // Present activityVC
            presentViewController(activityVC, animated: true, completion: nil)
        }
        
    }
}
