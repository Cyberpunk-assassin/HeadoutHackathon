//
//  AnnotationController.swift
//  Swagat_MyGola
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit
protocol AnnotationControllerDelegate : NSObjectProtocol
{
    func cancelButtonClicked ()
    func saveButtonClicked (newImage : UIImage, newCaption : String)
    func ProgressNoteCancelButtonClicked ()
}
var imageAnnotation : UIImageView = UIImageView()

class AnnotationController: UIViewController,UITextViewDelegate {
    var redoImage : UIImage?
    var selectedImage : UIImageView?
    var signView : UIView?
    var firstPoint : CGPoint?
    var mouseMoved : Int?
    var mouseSwiped : Bool?
    var lastPoint : CGPoint?
    
    var red : CGFloat?
    var green : CGFloat?
    var blue : CGFloat?
    var alpha : CGFloat?
    var isFromPatient : Bool?
    var size : CGSize = CGSize(width: 100, height: 100)
    var btnText : UIButton?
    var btnRedo : UIButton?
    var btnDone : UIButton?
    var btnCancel : UIButton?
    var bckGnd : UIImageView?
    var txtAnnotationDetails: UITextView = UITextView()
    var previousPoint1 : CGPoint?
    var previousPoint2 : CGPoint?
    var currentPoint : CGPoint?
    var strAnnotationName : String?
    var callBack : AnnotationControllerDelegate?
    var flag = false
    var checkEditing = false
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        txtAnnotationDetails.textAlignment = NSTextAlignment.Center
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        println("initWithNibname of AnnotationController")
        selectedImage = UIImageView()
        selectedImage!.tag = 666
        selectedImage!.userInteractionEnabled = true
        selectedImage!.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 0.3)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.designScreen()
        txtAnnotationDetails.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Done",comment:"Done")
        self.navigationController?.navigationBarHidden = true
        self.signView?.backgroundColor = UIColor.blackColor()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        orientationAllignment()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        orientationAllignment()
        txtAnnotationDetails.textAlignment = NSTextAlignment.Center
        checkEditing = true
        
    }
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        checkEditing = false
        orientationAllignment()
        return true
    }
  
  
  
    func doneButtonClicked ()
    {
        self.savePhysicianAnnotation()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func initialize ()
    {
        bckGnd = UIImageView()
        signView = UIView()
        btnText  =  UIButton()
        btnDone =   UIButton()
        btnCancel =   UIButton()
        txtAnnotationDetails.contentInset = UIEdgeInsetsMake(20, 0, 5, 0)
        btnRedo =   UIButton()
        
        self.view.addSubview(bckGnd!)
    }
    
    func orientationAllignment ()
    {
        
              bckGnd!.frame = CGRectMake(0, 0, 768, 1024)
              signView!.frame = CGRectMake(0, 0, 375, 667)
              
              selectedImage?.frame = CGRectMake(0, 95, 375, 375)
              btnText?.frame  = CGRectMake(454-50-114-150, 760-250, 25, 25)
              btnDone!.frame = CGRectMake(570-114-220, 235-200, 70, 25)
              btnCancel?.frame = CGRectMake(540-114-200, 760-250, 25, 25)
              txtAnnotationDetails.frame = CGRectMake(0, 0, 360, 90)
              btnRedo!.frame = CGRectMake(271-50-114-50, 760-250, 25, 25)
              
                println("Portrait")
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func designScreen ()
    {
        initialize()
        orientationAllignment()
        
        bckGnd!.backgroundColor = UIColor.blackColor()
        bckGnd!.alpha = 0.1
        self.view.addSubview(bckGnd!)
        
        signView!.backgroundColor = UIColor.blackColor()
        signView?.layer.cornerRadius = 9.0
        
        self.view.addSubview(signView!)
        signView!.addSubview(selectedImage!)
        
        btnRedo!.setBackgroundImage(UIImage(named: "icon_eraser"), forState: UIControlState.Normal)
        btnRedo!.layer.cornerRadius = 3.0
        btnRedo!.backgroundColor = UIColor.blackColor()
        btnRedo!.addTarget(self, action: "btnRedoClk:", forControlEvents: UIControlEvents.TouchUpInside)
        btnRedo?.enabled =  false
        self.view.addSubview(btnRedo!)
        
        
        
        btnText!.setBackgroundImage(UIImage(named: "Marker_icon.pdf"), forState: UIControlState.Normal)
        btnText!.layer.cornerRadius = 3.0
        btnText!.backgroundColor = UIColor.blackColor()
        btnText!.addTarget(self, action: "btnAnnotateClk:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(btnText!)
        
        btnDone!.layer.cornerRadius = 3.0
        btnDone!.backgroundColor = UIColor.blackColor()
        btnDone!.layer.borderWidth = 1.0
        btnDone!.layer.borderColor = UIColor.whiteColor().CGColor
        btnDone!.setTitle(NSLocalizedString("Done",comment:"Done"), forState: UIControlState.Normal)
        btnDone!.addTarget(self, action: "btnSaveClk:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnDone!)
        
        btnText?.layer.cornerRadius = 3.0
        btnCancel!.setBackgroundImage(UIImage(named: "icon_family_2x"), forState: UIControlState.Normal)
        btnCancel?.backgroundColor = UIColor.blackColor()
        btnCancel?.addTarget(self, action: "btnTextClk:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(btnCancel!)
        txtAnnotationDetails.alpha = 0.7
        txtAnnotationDetails.textColor = UIColor.blackColor()
        txtAnnotationDetails.font = UIFont(name: "HELVETICANEUE", size: 23)
        txtAnnotationDetails.backgroundColor = UIColor.whiteColor()
        txtAnnotationDetails.returnKeyType = UIReturnKeyType.Default
        txtAnnotationDetails.userInteractionEnabled = true
        if txtAnnotationDetails.text == "" {
            txtAnnotationDetails.hidden = true
        }
        txtAnnotationDetails.textAlignment = NSTextAlignment.Center
        self.selectedImage?.addSubview(txtAnnotationDetails)
        redoImage = selectedImage!.image
        
        self.checkForAnnotation()
    }
    
    func btnSaveClk (sender : UIButton) {
        if (self.callBack != nil && self.callBack!.respondsToSelector("saveButtonClicked:newCaption:")) {
            if selectedImage!.image != nil {
                self.callBack!.saveButtonClicked(selectedImage!.image!, newCaption: txtAnnotationDetails.text!)
            }
        }
        flag = false
    }
    
    func btnTextClk (sender : UIButton) {
        if txtAnnotationDetails.hidden {
            txtAnnotationDetails.hidden = false
        }
        else {
            txtAnnotationDetails.hidden = true
        }
        flag = false
    }
    
    // check for signature is present or not
    func checkForAnnotation () {
        if selectedImage!.image != nil {
            btnDone!.enabled = true
        }
    }
    
    func btnAnnotateClk(sender: UIButton) {
        flag = true
    }
    
    func btnRedoClk(sender : UIButton) {
        selectedImage!.image = redoImage
        flag = false
        self.checkForAnnotation()
    }
    
    // image
    func savePhysicianAnnotation () {
        var data : NSData = UIImagePNGRepresentation(selectedImage!.image)
        data.writeToFile(AppUtil.annotationPath(strAnnotationName!), atomically: true)
    }
    
    func cancelButtonClicked () {
        if (self.callBack != nil && self.callBack!.respondsToSelector("cancelButtonClicked")) {
            self.callBack!.cancelButtonClicked()
        }
    }
    
    func ProgressNoteCancelButtonClicked () {
        if (self.callBack != nil && self.callBack!.respondsToSelector("ProgressNoteCancelButtonClicked")) {
            self.callBack!.ProgressNoteCancelButtonClicked()
        }
    }
    
    func saveButtonClicked (newImage : UIImage, newCaption : String) {
        
    }
    
    func midPoint(p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch : UITouch? = (touches as NSSet).anyObject() as? UITouch
        
        previousPoint1 = touch?.previousLocationInView(touch!.view)
        previousPoint2 = touch?.previousLocationInView(touch!.view)
        currentPoint = touch?.locationInView(touch!.view)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch : UITouch? = (touches as NSSet).anyObject() as? UITouch
        
        if(flag == true) {
            previousPoint2 = previousPoint1
            previousPoint1 = touch?.previousLocationInView(touch!.view)
            currentPoint = touch?.locationInView(touch!.view)
            
            if touch!.view.tag == 666 {
                // calculate mid point
                var mid1 : CGPoint = midPoint(previousPoint1!, p2: previousPoint2!)
                var mid2 : CGPoint = midPoint(currentPoint!, p2: previousPoint1!)
                
                
                UIGraphicsBeginImageContext(selectedImage!.frame.size);
                var context : CGContextRef = UIGraphicsGetCurrentContext()
                selectedImage!.image?.drawInRect(CGRectMake(0, 0, selectedImage!.frame.size.width, selectedImage!.frame.size.height))
                
                CGContextMoveToPoint(context, mid1.x, mid1.y)
                // Use QuadCurve is the key
                CGContextAddQuadCurveToPoint(context, previousPoint1!.x, previousPoint1!.y, mid2.x, mid2.y)
                
                CGContextSetLineCap(context, kCGLineCapRound)
                CGContextSetLineWidth(context, 2.5)
                
                
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 236.0/255.0, 93.0/255.0, 87.0/255.0, 1.0)
                
                
                CGContextStrokePath(context)
                selectedImage!.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch : UITouch? = (touches as NSSet).anyObject() as? UITouch
        
        if(flag == true) {
            previousPoint2 = previousPoint1
            previousPoint1 = touch?.previousLocationInView(touch!.view)
            currentPoint = touch?.locationInView(touch!.view)
            
            if touch!.view.tag == 666 {
                // calculate mid point
                var mid1 : CGPoint = midPoint(previousPoint1!, p2: previousPoint2!)
                var mid2 : CGPoint = midPoint(currentPoint!, p2: previousPoint1!)
                
                
                UIGraphicsBeginImageContext(selectedImage!.frame.size);
                
                var context : CGContextRef = UIGraphicsGetCurrentContext()
                selectedImage!.image?.drawInRect(CGRectMake(0, 0, selectedImage!.frame.size.width, selectedImage!.frame.size.height))
                
                CGContextMoveToPoint(context, mid1.x, mid1.y)
                // Use QuadCurve is the key
                CGContextAddQuadCurveToPoint(context, previousPoint1!.x, previousPoint1!.y, mid2.x, mid2.y)
                
                CGContextSetLineCap(context, kCGLineCapRound)
                CGContextSetLineWidth(context, 2.5)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 236.0/255.0, 93.0/255.0, 87.0/255.0, 1.0)
                
                
                CGContextStrokePath(context)
                
                selectedImage!.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                self.checkForAnnotation()
            }
            btnRedo?.enabled =  true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        orientationAllignment()
    }
    
}
