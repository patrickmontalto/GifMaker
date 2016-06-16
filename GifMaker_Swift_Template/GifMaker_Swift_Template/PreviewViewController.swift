//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/15/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var gif: Gif?
    @IBOutlet var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let gif = gif {
            gifImageView.image = gif.gifImage
        }
    }
    @IBAction func shareGif(sender: AnyObject) {
        // Get animated GIF as NSData
        if let gif = gif, url = gif.url {
            /* GUARD: Does animatedGif exist as NSData? */
            guard let animatedGif = NSData(contentsOfFile: url.absoluteString) else {
                print("Error getting NSData from url.")
                return
            }
            let itemsToShare = [animatedGif]
            
            // Create share controller
            let shareController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            
            // Set completion with items handler
            shareController.completionWithItemsHandler = {
                (activityType, completed, returnedItems, activityError) in
                if completed {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            presentViewController(shareController, animated: true, completion: nil)
            
        }
        
    }
}
