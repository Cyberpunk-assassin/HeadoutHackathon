//
//  AnnotationCollectionViewCell.swift
//  Swagat_MyGola
//
//  Created by Swagat Kumar Bisoyi on 7/25/15.
//  Copyright (c) 2015 Swagat Kumar Bisoyi. All rights reserved.
//

import UIKit

protocol AnnotationCollectionViewCellDelegate : NSObjectProtocol {
    func annotationCollectionViewCellOnRemove(indexPos:NSIndexPath)
}


class AnnotationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAnnoted: UIImageView!

    var removeBtn:UIButton!
    var indexValue : NSIndexPath = NSIndexPath()
    var delegate:AnnotationCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
        self.removeBtn = UIButton()
        self.removeBtn.setImage(UIImage(named: "icon_close"), forState: UIControlState.Normal)
        self.removeBtn.addTarget(self, action: "onRemove:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.removeBtn)
        imgAnnoted.layer.cornerRadius = 5.0
        self.reset() //reset all frames
        self.onMode(self.mode) //set defalt mode
        self.removeBtn.hidden = true //don't show animation on init
        
    }
    var mode:Int = 0 {
        didSet {
            self.onMode(self.mode)
        }
    }    //reset all frames

    func onDeselected() {
        self.contentView.alpha = 1
    }
    private func reset() {
        
        self.removeBtn.transform = CGAffineTransformIdentity //must reset transform before setting the frame
        self.removeBtn.frame = CGRectMake(125, 0, 44, 44)
        
        self.transform = CGAffineTransformIdentity
        self.hidden = false
        self.removeBtn.hidden = true
    }

    func onRemove(sender:AnyObject) {
        self.delegate?.annotationCollectionViewCellOnRemove(indexValue)
    }

    private func onMode(mode:Int) {
        self.onDeselected()
            if mode == 1 {
                self.removeBtn.hidden = false
            }
            else {
                self.removeBtn.hidden = true
            }
        
        let duration:NSTimeInterval = mode == 0 ? 0.1 : 0.5
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
            let toTransform:CGAffineTransform = mode == 0 ? CGAffineTransformMakeScale(0.01, 0.01) : CGAffineTransformIdentity
            self.removeBtn.transform = toTransform
            
            }, completion: {(finished:Bool) -> Void in
                
                self.removeBtn.hidden = mode == 0
                
        })
        
        //add/remove wiggle animation
            mode == 1 ? self.wiggle() : self.layer.removeAllAnimations()

    }
    
    //show wiggle animation for edit mode
    private func wiggle()
    {
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle:CGFloat = 0.01
        let valLeft:NSValue = NSValue(CATransform3D: CATransform3DMakeRotation(wobbleAngle, 0, 0, 0.75))
        let valRight:NSValue = NSValue(CATransform3D: CATransform3DMakeRotation(-wobbleAngle, 0, 0,0.75 ))
        animation.values = [valLeft, valRight]
        animation.autoreverses = true
        animation.duration = 0.1
        animation.repeatCount = Float.infinity
        
        self.layer.addAnimation(animation, forKey: "transform")
    }

}
