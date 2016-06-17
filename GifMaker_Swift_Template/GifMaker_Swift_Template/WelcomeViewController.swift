//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/15/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var defaultGifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        defaultGifImageView.image = UIImage.gifWithName("tinaFeyHiFive")
        
        // User did see welcome view screen
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UserDidSeeWelcomeViewScreen")
        
    }
}