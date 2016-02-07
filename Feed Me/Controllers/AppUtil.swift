//
//  AppUtil.swift
//  Swagat_MyGola
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit
var arrAllValues = NSMutableArray()

class AppUtil: NSObject {
    
    //use this function to access appDelegate shared Instance
    class func APP_DELEGATE () -> AppDelegate {
        var delegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate
    }
//    
    class func getLayerWithBorderColor (color: CGColorRef, borderWidth: CGFloat, frame: CGRect) -> CALayer
    {
        var rightBorder : CALayer = CALayer()
        rightBorder.borderColor = color
        rightBorder.borderWidth = borderWidth
        rightBorder.frame = frame
        return rightBorder
    }
    
    
    class func applicationDocPath () -> String
    {
        var directory : String = ((NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).count > 0 ? (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).objectAtIndex(0) : "") as! String
        
        return directory
    }
    
    class func annotationPath (fileName : String) -> String
    {
        var annotationPath : String = AppUtil.applicationDocPath() + "/" + fileName
        return annotationPath
    }
    
    //method reload menu1 and returns array of menu objects
    //method reload menu2 and returns array of menu objects
    
    
}
