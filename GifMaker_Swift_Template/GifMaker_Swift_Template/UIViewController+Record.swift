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
import AVFoundation

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
            // Dismiss view controller
            dismissViewControllerAnimated(true, completion: nil)
            // Crop video to square & convert video to GIF
            cropVideoToSquare(rawVideoURL, start: startTime, duration: duration)
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
    
    // MARK: Crop Video to Square
    func cropVideoToSquare(rawVideoURL: NSURL, start: Float?, duration: Float?) {
        // Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(URL: rawVideoURL)
        let videoTrack = videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0]
        
        // Crop to Square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        // Rotate to Portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2)
        let t2 = CGAffineTransformRotate(t1, CGFloat(M_PI_2))
        
        let finalTransform = t2
        transformer.setTransform(finalTransform, atTime: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export
        guard let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality) else {
            print("Error exporting video")
            return
        }
        exporter.videoComposition = videoComposition
        
        let path = createPath()
        exporter.outputURL = NSURL.fileURLWithPath(path)
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        var croppedURL: NSURL?
        
        exporter.exportAsynchronouslyWithCompletionHandler { () -> Void in
            croppedURL = exporter.outputURL
            self.convertVideoToGIF(croppedURL!, start: start, duration: duration)
        }
        
        
    }
    
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0]
        let manager = NSFileManager.defaultManager()
        var outputURL = (documentsDirectory as NSString).stringByAppendingPathComponent("output")
        do {
            try manager.createDirectoryAtPath(outputURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error)
            print("An error occurred creating directory at path.")
        }
        outputURL = (outputURL as NSString).stringByAppendingPathComponent("output.mov")
        
        // Remove existing file
        do {
           try manager.removeItemAtPath(outputURL)
        } catch let error as NSError {
            print(error)
            print("An error occurred removing item at path")
        }
        
        return outputURL
    }
}











