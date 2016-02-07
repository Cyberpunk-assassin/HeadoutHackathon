//
//  ShowDetailTableViewControllrViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class ShowDetailViewControllrViewController: UIViewController,UITextFieldDelegate {

  var eventDataList: [EventDetails] = []
  var selectedIndex : NSIndexPath!
  var director : String!
  var genre : String!
  var actors : String!
  var picURL = ""

  @IBOutlet weak var language: UILabel!
  @IBOutlet weak var showTitle: UILabel!
  
  @IBOutlet weak var bannerImage: UIImageView!

  @IBOutlet weak var descTextView: UITextView!
  @IBOutlet weak var numberOfSeats: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
//      let url = NSURL(string: picURL)
//      if let data = NSData(contentsOfURL: url!)        //make sure your image in this url does exist, otherwise unwrap in a if let check
//      {
        bannerImage.image = UIImage(named: picURL)
      //}
      descTextView.text = "Genre : \(genre)\nActors : \(actors) \nDirector : \(director)"
      descTextView.userInteractionEnabled = false
      showTitle.text = self.eventDataList[selectedIndex.row].valueForKey("EventTitle") as? String
      language.text = "(" + (self.eventDataList[selectedIndex.row].valueForKey("Language") as? String)! + ")"
      
      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    numberOfSeats.resignFirstResponder()
  }
  
  @IBAction func BookButtonPressed(sender: AnyObject) {
//     let num = self.numberOfSeats.text.toInt()
//    if (num != 0 && num != nil)
//    {
//      performSegueWithIdentifier("SelectSeat", sender: self)
//
//    }
//    else{
//      let errorAlert = UIAlertView(title: "No Seats Entered", message: "Please enter the number of seats you want to book.", delegate: self, cancelButtonTitle: "OK")
//      errorAlert.show()
//    }
//
  }
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    numberOfSeats.resignFirstResponder()
    return true
  }
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    numberOfSeats.resignFirstResponder()
    return true
  }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//      let num = self.numberOfSeats.text.toInt()
//      if (num != 0 && num != nil)
//      {
      if segue.identifier == "SelectSeat"{
        let controller = segue.destinationViewController as! SeatSelectionViewController
        
        controller.numOfSeats = self.numberOfSeats.text.toInt()
        }
//  }     Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      }
  
  

}
