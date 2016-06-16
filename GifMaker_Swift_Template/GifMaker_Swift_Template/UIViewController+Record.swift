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
let loopCount = 0 // 0 means infinite loop

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Present Video Camera
    @IBAction func launchVideoCamera(sender: AnyObject) {
        
        // create imagePicker
        let recordVideoControler = UIImagePickerController()
        
        // Set properties: sourceType, mediaTypes, allowsEditing, delegate
        recordVideoControler.sourceType = UIImagePickerControllerSourceType.Camera
        recordVideoControler.mediaTypes = [kUTTypeMovie as String]
        recordVideoControler.allowsEditing = false
        recordVideoControler.delegate = self
        
        // Present controller
        presentViewController(recordVideoControler, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerController Delegate
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get media type
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        // If media type is movie, save raw video URL
        if mediaType == kUTTypeMovie as String {
            let rawVideoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            
            // Dismiss view controller
            dismissViewControllerAnimated(true, completion: nil)
            // Convert video to GIF
            convertVideoToGIF(rawVideoURL)
            //UISaveVideoAtPathToSavedPhotosAlbum(rawVideoURL.path!, nil, nil, nil)
            
            // TODO: Get start and end points for trimmed video
            
            // TODO: Crop video to square
        }
        
        
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - GIF Conversion Methods
    func convertVideoToGIF(videoURL: NSURL) {
        let regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
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











