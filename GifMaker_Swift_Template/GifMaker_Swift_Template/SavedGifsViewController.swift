
//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/17/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, PreviewViewControllerDelegate {
    
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    @IBOutlet var emptyView: UIStackView!
    @IBOutlet var collectionView: UICollectionView!
    var gifsFilePath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("savedGifs")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the emptyView if there are any savedGifs
        emptyView.hidden = (savedGifs.count != 0)
        
        // Unarchive saved gifs array
        savedGifs = NSKeyedUnarchiver.unarchiveObjectWithFile(gifsFilePath) as! [Gif]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Bar
        title = "My Collection"
        self.navigationController?.navigationBar.hidden = savedGifs.count == 0
        collectionView.reloadData()
        
    }
    
    // MARK: - Preview View Controller
    func previewVC(didSaveGif gif: Gif) {
        if let gifURL = gif.url {
            // Set gifData
            gif.gifData = NSData(contentsOfURL: gifURL)
            // Append to array
            savedGifs.append(gif)
            // Save array of gifs
            NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
        }
        
    }
    
    // MARK: - Show Welcome View Controller
    func showWelcomeVC() {
        if NSUserDefaults.standardUserDefaults().boolForKey("UserDidSeeWelcomeViewScreen") != true {
            let welcomeVC = self.storyboard?.instantiateViewControllerWithIdentifier("WelcomeViewController") as! WelcomeViewController
            navigationController?.presentViewController(welcomeVC, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionView Delegate & Data Source
extension SavedGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GifCell", forIndexPath: indexPath) as! GifCell
        
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.gif = savedGifs[indexPath.item]
        
        detailVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(detailVC, animated: true, completion: nil)
    }
    
    // MARK: CollectionView Flow Layout: 2 Columns of Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2.0))/2
        return CGSizeMake(width, width)
    }
}