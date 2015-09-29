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
        
        self.view.backgroundColor = UIColor.blackColor()
        
        // Enable camera button?
        self.camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setUpTextFields()
        self.shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Subscribe to keyboard notification
        self.subscribeToKeyboardNotifications()
        
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: -
    // MARK: Utility methods
    
    //****************************
    // Setting up the text fields
    //****************************
    func setUpTextFields() {
        //Background, hide border
        self.topTextField.backgroundColor = UIColor.clearColor()
        self.bottomTextField.backgroundColor = UIColor.clearColor()
        self.topTextField.borderStyle = UITextBorderStyle.None
        self.bottomTextField.borderStyle = UITextBorderStyle.None
        
        //Set text field properties
        //Initial text
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        
        //Text field alignment
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = .Center
        
        //Set default text attributes
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    
    // Pick an image and set up the image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.imagePickerView.image = image
        self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
        self.shareButton.enabled = true
    }
    
    // Cancel the image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.shareButton.enabled = false
    }
    
    //Pick an image from albums
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //Take a pic from the camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
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
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //Shift view when keyboard shows
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
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
        self.toolBar.hidden = true
        self.topToolBar.hidden = true
        
        // Render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar
        self.toolBar.hidden = false
        self.topToolBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(memeImage: UIImage) {
        var meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, initialImage: imagePickerView.image!, memeImage: memeImage)
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

