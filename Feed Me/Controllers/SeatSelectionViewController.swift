//
//  SeatSelectionViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class SeatSelectionViewController: UIViewController, UIAlertViewDelegate {
  
  var numOfSeats :Int!
  
  @IBOutlet var seatBtn: [UIButton]!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    seatBtn[0].tag = 100
    for (var i = 0; i <= seatBtn.count-1; i++)
    {
      seatBtn[i].setBackgroundImage(UIImage(named: "seat-disabled"), forState: UIControlState.Normal)
      if i != 0{
        seatBtn[i].tag += 1
      }
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func seatSelected(sender: AnyObject) {
    
    //demo
    
    for i in 0...seatBtn.count-1
    {
      seatBtn[i].setBackgroundImage(UIImage(named: "seat-disabled"), forState: UIControlState.Normal)
    }
    
    for i in 0...seatBtn.count-1
    {
      if seatBtn[i] == sender as! NSObject
      {
        for j in 0...numOfSeats-1
        {
          seatBtn[i+j].setBackgroundImage(UIImage(named: "seat-occupied"), forState: UIControlState.Normal)
          
          UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.seatBtn[i].transform = CGAffineTransformMakeScale(1.1, 1.1);
            }) { (finished) -> Void in
              UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                self.seatBtn[i].transform = CGAffineTransformMakeScale(1.0, 1.0);
                }, completion: nil)
          }
          
        }
      }
    }
    
    
    
    
    //    for i in 0...seatBtn.count-1
    //    {
    //      if sender.tag < i
    //      {
    //        seatBtn[i].setBackgroundImage(UIImage(named: "seat-disabled"), forState: UIControlState.Normal)
    //      }
    //      else
    //      {
    //        seatBtn[i].setBackgroundImage(UIImage(named: "seat-occupied"), forState: UIControlState.Normal)
    //
    //        UIView.animateWithDuration(0.15, animations: { () -> Void in
    //          self.seatBtn[i].transform = CGAffineTransformMakeScale(1.1, 1.1);
    //          }) { (finished) -> Void in
    //            UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
    //              self.seatBtn[i].transform = CGAffineTransformMakeScale(1.0, 1.0);
    //              }, completion: nil)
    //        }
    //
    //      }
    //    }
    
    //real
    //    var flag : Bool = false
    //    if (sender.tag != nil) {
    //      seatBtn[sender.tag].setBackgroundImage(UIImage(named: "seat-occupied"), forState: UIControlState.Normal)
    //      flag = true
    //
    //    }
    //
    //for i in 0...sender.tag+numOfSeats-1
    //    {
    //      if sender.tag < i
    //      {
    //        seatBtn[i].setBackgroundImage(UIImage(named: "seat-disabled"), forState: UIControlState.Normal)
    //      }
    //      else
    //      {
    //        seatBtn[i].setBackgroundImage(UIImage(named: "seat-occupied"), forState: UIControlState.Normal)
    //
    //        UIView.animateWithDuration(0.15, animations: { () -> Void in
    //          self.seatBtn[i].transform = CGAffineTransformMakeScale(1.1, 1.1);
    //          }) { (finished) -> Void in
    //            UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
    //              self.seatBtn[i].transform = CGAffineTransformMakeScale(1.0, 1.0);
    //              }, completion: nil)
    //        }
    //
    //      }
    //    }
  }
  @IBAction func seatSelectionCompletedBtn(sender: AnyObject) {
    
    let alert = UIAlertView(title: "", message: "Are You sure You want to book the Cab?", delegate:self, cancelButtonTitle:"No", otherButtonTitles: "Yes")
    alert.tag = 111
    alert.show()

    
  }
  
  func alertView(alertView: UIAlertView,
    clickedButtonAtIndex buttonIndex: Int)
  {
    
    if alertView.tag == 111 {
      
      if buttonIndex == 1 {
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var cabHistoryViewController : CabDetailsViewController = storyBoard.instantiateViewControllerWithIdentifier("CabDetailsViewController") as! CabDetailsViewController
        self.navigationController?.pushViewController(cabHistoryViewController, animated: false)
        
      }
    }
  }

  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
