//
//  ViewController.swift
//  MemeMe
//
//  Created by ANISHA AGARWAL on 9/24/15.
//  Copyright (c) 2015 Anisha Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
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
        //Subscribe to keyboard notification
        self.subscribeToKeyboardNotifications()
        
        // Enable camera button?
        self.camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setUpTextFields()
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
        
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
        self.topTextField.textAlignment = .Center
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
    }
    
    // Cancel the image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        println("before show")
        println(self.view.frame.origin.y)
        let keyboardHeight = getKeyboardHeight(notification)
        println(keyboardHeight)
        self.view.frame.origin.y = 0.0 - keyboardHeight
        println("after show")
        println(self.view.frame.origin.y)
    }
    
    //Shift view when keyboard shows
    func keyboardWillHide(notification: NSNotification) {
        println("before hide")

        println(self.view.frame.origin.y)
        let keyboardHeight = getKeyboardHeight(notification)
        self.view.frame.origin.y = 0.0
        println("after hide")

        println(self.view.frame.origin.y)
    }
    
    //Get height of keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }


}

