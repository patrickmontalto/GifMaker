//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Patrick on 6/15/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// Constants for Regift
let frameCount = 16
let delayTime: Float = 0.2
let frameRate = 15
let loopCount = 0 // 0 means infinite loop

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Present Video Options
    @IBAction func presentVideoOptions() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            self.launchPhotoLibrary()
        } else {
            // Make new alert controller - action sheet style
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            // Make actions: recordVideo, chooseFromExisting, cancel
            let recordVideo = UIAlertAction(title: "Record a Video", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.launchVideoCamera()
            })
            
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .Default, handler: { (alert) -> Void in
                self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            presentViewController(newGifActionSheet, animated: true, completion: nil)
            newGifActionSheet.view.tintColor = UIColor(red: 1.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        }
        
    }
    
    // MARK: Present Photo Library
    func launchPhotoLibrary() {
        
        let photoPickerController = imagePickerWithSource(UIImagePickerControllerSourceType.PhotoLibrary)
        
        // Present controller
        presentViewController(photoPickerController, animated: true, completion: nil)
    }
    
    // MARK: Present Video Camera
    func launchVideoCamera() {
        
        let recordVideoControler = imagePickerWithSource(UIImagePickerControllerSourceType.Camera)
        
        // Present controller
        presentViewController(recordVideoControler, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerController Creation
    func imagePickerWithSource(source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        
        pickerController.sourceType = source
        pickerController.mediaTypes = [kUTTypeMovie as String]
        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        return pickerController
    }
    
    // MARK: UIImagePickerController Delegate
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get media type
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        // If media type is movie, save raw video URL
        if mediaType == kUTTypeMovie as String {
            let rawVideoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            
            // Get start time & duration
            let startTime = info["_UIImagePickerControllerVideoEditingStart"] as? Float
            let endTime = info["_UIImagePickerControllerVideoEditingEnd"] as? Float
            var duration: Float?
            
            if let startTime = startTime, endTime = endTime {
                duration = endTime - startTime

            }
            // TODO: Crop video to square
            
            // Dismiss view controller
            dismissViewControllerAnimated(true, completion: nil)
            // Convert video to GIF
            convertVideoToGIF(rawVideoURL, start: startTime, duration: duration)
        }
        
        
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - GIF Conversion Methods
    func convertVideoToGIF(videoURL: NSURL, start: Float?, duration: Float?) {
        var regift: Regift;
        
        if let start = start, duration = duration {
            // Trimmed
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start, duration: duration, frameRate: frameRate, loopCount: loopCount)
        } else {
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        
        let gifURL = regift.createGif()
        let gif = Gif(GifUrl: gifURL!, videoURL: videoURL, caption: nil)
        displayGIF(gif)
    }
    
    func displayGIF(gif: Gif) {
        // Instantiate gif editor view controller
        let gifEditorVC = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController") as! GifEditorViewController
        // Set gif url
        gifEditorVC.gif = gif
        // Push ontop of Navigation stack
        navigationController?.pushViewController(gifEditorVC, animated: true)
        
    }
}











