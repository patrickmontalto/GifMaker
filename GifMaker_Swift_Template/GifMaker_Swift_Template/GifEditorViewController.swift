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
        let keyboardFrameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrameEndRect = keyboardFrameEnd.CGRectValue()
        return keyboardFrameEndRect.size.height
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
