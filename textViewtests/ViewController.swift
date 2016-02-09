//
//  ViewController.swift
//  textViewtests
//
//  Created by coyote on 04/02/16.
//  Copyright © 2016 coyote. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var scrollViewChild: UIView!
    @IBOutlet weak var attachHolder: UIView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var attachButtonBottom: NSLayoutConstraint!
    var keyboardSize : CGFloat = 0
    var attachedImageView : UIImageView!
    @IBOutlet weak var textView: UITextView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterForKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        placeholderLabel = UILabel()
        placeholderLabel.text = "Ecrivez ici ..."
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, textView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = !textView.text.isEmpty
        attachButtonBottom.constant = 0
        attachHolder.userInteractionEnabled = true
        attachHolder.frame.size.height = 0
        attachHolder.superview?.frame.size.height = textView.frame.height
        attachHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("textViewBecomeFirstResponder:")))
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textViewHeight.constant = textView.contentSize.height
        view.layoutIfNeeded()
        textView.becomeFirstResponder()
    }
    func textViewBecomeFirstResponder(sender : UITapGestureRecognizer){
        if(!textView.isFirstResponder()){
            textView.becomeFirstResponder()
        }else{
            textView.resignFirstResponder()
        }
    }
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    func deRegisterForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func keyboardWillShow(notification: NSNotification){
        var info = notification.userInfo!
        keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size.height
        attachButtonBottom.constant = keyboardSize
        //conntainerViewHeight.constant -= keyboardSize
            self.view.layoutIfNeeded()
    }
    func keyboardWillHide(notification: NSNotification){
        attachButtonBottom.constant = 0
        //conntainerViewHeight.constant += keyboardSize
        self.view.layoutIfNeeded()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func attachImage(sender: AnyObject) {
        if attachedImageView == nil{
            let image = UIImage(named: "baby")
            let ratio = (image?.size.width)! / textView.frame.width
            
            attachedImageView = UIImageView(frame: CGRect(x: 0, y: textView.frame.height , width: textView.frame.width, height: (image?.size.height)! / ratio))
            attachedImageView.image = image
            attachHolder.addSubview(attachedImageView)
            
        }else{
    
            attachedImageView.removeFromSuperview()
            attachedImageView = nil
            
        }
        view.layoutIfNeeded()
        
    }
    
    
}

extension ViewController : UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
        textViewHeight.constant = textView.contentSize.height
        let addedHeight = (attachedImageView == nil) ? 0.0:attachedImageView.frame.height
        textView.superview?.frame.size.height = textView.contentSize.height + addedHeight
        view.layoutIfNeeded()
    }
}