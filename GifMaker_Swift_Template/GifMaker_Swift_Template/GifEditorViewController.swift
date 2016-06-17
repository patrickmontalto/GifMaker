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
    @IBOutlet var captionTextField: UITextField!
    var gif: Gif?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        gifImageView.image = gif?.gifImage
        
        // Caption Text Field delegate
        captionTextField.delegate = self
        
        // Subscribe to keyboard notifications to adjust view to accommodate keyboard
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Adjusting View to Accommodate Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if self.view.frame.origin.y >= 0 {
            var rect = self.view.frame
            rect.origin.y = rect.origin.y - getKeyboardHeight(notification)
            self.view.frame = rect;
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            var rect = self.view.frame
            rect.origin.y = rect.origin.y + getKeyboardHeight(notification)
            self.view.frame = rect
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func presentPreview(sender: AnyObject) {
        if let gif = gif {
            // Create Gif Preview View Controller
            let previewVC = self.storyboard?.instantiateViewControllerWithIdentifier("PreviewViewController") as! PreviewViewController
            
            // Set gif caption
            gif.caption = captionTextField.text
        
            // Create new instance of Regift
            var regift = Regift.init(sourceFileURL: gif.videoURL!, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
            
            // Set font for caption
            let captionFont = captionTextField.font
            
            // Create gif as NSURL
            let gifURL = regift.createGif(caption: gif.caption, font: captionFont)
            
            // Create new instance of Gif object
            let newGif = Gif(GifUrl: gifURL!, videoURL: gif.videoURL!, caption: gif.caption)
            
            // Set gif on previewVC
            previewVC.gif = newGif
            
            // Set delegate on previewVC to SavedGifsViewController
            previewVC.delegate = self.navigationController?.viewControllers.first as! SavedGifsViewController
            
            // Push previewVC ontop of nav stack
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
        
        
        //
    }
}

// MARK: - UITextFieldDelegate
extension GifEditorViewController: UITextFieldDelegate {
    
    // Dismiss keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Clear placeholder when beginning editing
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }
    
}
