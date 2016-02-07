//
//  CustomAnnotation.swift
//  Swagat_MyGola
//
//  Created by Swagat Kumar Bisoyi on 7/24/15.
//  Copyright (c) 2015 Swagat Kumar Bisoyi. All rights reserved.
//


import UIKit
import MapKit

public extension UIImage {
    
    public class func resizeImage(imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    class func createAvatar(inputImage: UIImage, ringColor: UIColor) -> UIImage {
        
        // if the image isn't square we need to do a center crop
        var squareInputImage = inputImage
        
        if (inputImage.size.width != inputImage.size.height) {
            squareInputImage = UIImage.squareCropImage(inputImage)
        }
        
        // do the actual drawing
        UIGraphicsBeginImageContext(squareInputImage.size)
        
        let contextRef = UIGraphicsGetCurrentContext()
        let squareRect = CGRectMake(0, 0, squareInputImage.size.width, squareInputImage.size.height)
        let roundPath = UIBezierPath(ovalInRect: squareRect)
        roundPath.addClip()
        
        squareInputImage.drawAtPoint(CGPointZero)
        
        let strokePath = UIBezierPath(ovalInRect: CGRectInset(squareRect, 4, 4))
        strokePath.lineWidth = 2
        CGContextSetStrokeColorWithColor(contextRef, ringColor.CGColor)
        strokePath.stroke()
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    /**
    Takes a non-square image and returns a square image.
    */
    class func squareCropImage(inputImage: UIImage) -> UIImage {
        let imageSize = inputImage.size
        var cropRect = CGRectZero
        
        if imageSize.width < imageSize.height {
            let squareSize = imageSize.width
            cropRect = CGRectMake(0, (imageSize.height - squareSize)*0.5, squareSize, squareSize)
        } else {
            let squareSize = imageSize.height
            cropRect = CGRectMake((imageSize.width - squareSize)*0.5, 0, squareSize, squareSize)
        }
        
        cropRect = CGRectIntegral(cropRect)
        
        let returnCgImage = CGImageCreateWithImageInRect(inputImage.CGImage, CGRectMake(0, 0, cropRect.width, cropRect.height))
        
        return UIImage(CGImage: returnCgImage, scale: 1.0, orientation: inputImage.imageOrientation)!
    }

}

class CustomView: MKAnnotationView {
    
    var imageView:UIImageView=UIImageView()
    var lblText:UILabel=UILabel()
    var lblCash:UILabel=UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRectMake(0, 0, 150, 150)
        
        lblText.frame = CGRectMake(0, 0, 30, 15)
        lblCash.frame = CGRectMake(0, 0, 20, 15)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        imageView.image = super.image
        lblText.textColor = UIColor.whiteColor()
        lblText.font = UIFont.boldSystemFontOfSize(15)
        lblText.center = CGPointMake(25, 15)
        lblText.textAlignment = NSTextAlignment.Center
        lblCash.textColor = UIColor.whiteColor()
        lblCash.font = UIFont.boldSystemFontOfSize(14)
        lblCash.center = CGPointMake(25, 35)
        lblCash.textAlignment = NSTextAlignment.Center
        self.addSubview(imageView)
        self.addSubview(lblText)
        self.addSubview(lblCash)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    

}
