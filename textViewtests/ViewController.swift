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
    @IBOutlet weak var conntainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var attachButtonBottom: NSLayoutConstraint!
    var keyboardSize : CGFloat = 0
    var attachedImageView : UIImageView!
    var attachHolderBottomConstraintHeight : CGFloat!
    
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
        attachHolderBottomConstraintHeight = attachButtonBottom.constant
        attachHolder.userInteractionEnabled = true
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
        conntainerViewHeight.constant -= keyboardSize
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
            },completion: nil)
        
        
    }
    func keyboardWillHide(notification: NSNotification){
        attachButtonBottom.constant = attachHolderBottomConstraintHeight
        conntainerViewHeight.constant += keyboardSize
        UIView.animateWithDuration(0.1, animations: {
            self.view.layoutIfNeeded()
            },completion: nil)
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
            let currentViewHeight = scrollViewChild.frame.height
            let shouldBe = attachedImageView.frame.height + textView.frame.height
            let offset = currentViewHeight - shouldBe
            conntainerViewHeight.constant += offset
            
        }else{
            conntainerViewHeight.constant -= attachedImageView.frame.height
            attachedImageView.removeFromSuperview()
            attachedImageView = nil
            
        }
        view.layoutIfNeeded()
        
    }
    
    
}

extension ViewController : UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        let lastConstant = textViewHeight.constant
        placeholderLabel.hidden = !textView.text.isEmpty
        textViewHeight.constant = textView.contentSize.height
        let diff = textView.contentSize.height - lastConstant
        conntainerViewHeight.constant += diff
        view.layoutIfNeeded()
    }
}