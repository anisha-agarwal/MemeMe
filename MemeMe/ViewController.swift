//
//  ViewController.swift
//  MemeMe
//
//  Created by ANISHA AGARWAL on 9/24/15.
//  Copyright (c) 2015 Anisha Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //Default text attributes for the meme text fields
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.blackColor()
        
        // Enable camera button?
        camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setUpTextFields(topTextField, text: "TOP")
        setUpTextFields(bottomTextField, text: "BOTTOM")
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Subscribe to keyboard notification
        subscribeToKeyboardNotifications()
        
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: -
    // MARK: Utility methods
    
    //****************************
    // Setting up the text fields
    //****************************
    func setUpTextFields(textField: UITextField, text: String) {
        //Background, hide border
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = UITextBorderStyle.None
        
        //Set text field properties
        //Initial text
        textField.text = text
        
        //Text field alignment
        textField.textAlignment = NSTextAlignment.Center
        
        //Set default text attributes
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    
    // Pick an image and set up the image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePickerView.image = image
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    // Cancel the image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = false
    }
    
    //Pick an image from albums
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //Take a pic from the camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Keyboard sliding
    
    //Subscribe to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribe from keyboard notification
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object:nil)
    }
    
    //Shift view when keyboard shows
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //Shift view when keyboard shows
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Get height of keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    // MARK: -
    // MARK: Generate/Save meme
    
    // Generate the memed image, including text and no toolbar
    func generateMemedImage() -> UIImage {
        // hide toolbar
        toolBar.hidden = true
        topToolBar.hidden = true
        
        // Render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar
        toolBar.hidden = false
        topToolBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(memeImage: UIImage) {
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, initialImage: imagePickerView.image!, memeImage: memeImage)
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memeImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activityType: String!, completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) -> Void in
            if completed {
                // Save meme and dismiss
                self.saveMeme(memeImage)
                activityController.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }


}

