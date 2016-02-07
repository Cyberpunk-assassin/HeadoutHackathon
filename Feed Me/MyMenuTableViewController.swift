//
//  MyMenuTableViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class MyMenuTableViewController: UITableViewController {
  var selectedMenuItem : Int = 0
  
  var arrayMenu = ["Profile", "Book A Cab", "Book a Movie", "Book a Restaurant", "Book a flight", "Chat", "Tweet", "Feedback"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Customize apperance of table view
    tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
    tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    tableView.separatorColor = UIColor.blackColor()
    tableView.backgroundColor = UIColor.clearColor()
    tableView.scrollsToTop = false
    tableView.showsVerticalScrollIndicator = false

    
    // Preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false
    tableView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
    
    tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return arrayMenu.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 0
    {
      return 150
    }
      return 50
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
    
    
    if (cell == nil) {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
      cell!.backgroundColor = UIColor.clearColor()
      cell!.textLabel!.font = UIFont(name: "HELVETICANEUE", size: 12)
      
      cell!.textLabel?.textColor = UIColor.whiteColor()
      
      let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
      selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
      cell!.selectedBackgroundView = selectedBackgroundView
      cell!.textLabel?.text = arrayMenu[indexPath.row]
      if indexPath.row == 0
      {
        var labelName = UILabel(frame: CGRect(x: 15, y: 65, width: 200, height: 90))
        var labelLocation = UILabel(frame: CGRect(x: 57, y: 120, width: 200, height: 30))
        labelLocation.font = UIFont.systemFontOfSize(14)
        labelName.font = UIFont.systemFontOfSize(16)
        var imagePic = UIImageView(frame: CGRect(x: 50, y: 17, width: 80, height: 80))
        imagePic.image = UIImage(named: "dp")
        imagePic.layer.borderWidth=1.0
        imagePic.layer.masksToBounds = false
        imagePic.layer.borderColor = UIColor.whiteColor().CGColor
        imagePic.layer.cornerRadius = 13
        imagePic.layer.cornerRadius = imagePic.frame.size.height/2
        imagePic.clipsToBounds = true
        
        labelName.text = "Ashima Nayyar"
        labelLocation.text = "Bangalore"
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
        cell!.backgroundColor = UIColor.clearColor()
        cell!.textLabel!.font = UIFont(name: "HELVETICANEUE", size: 14)
        
        cell!.textLabel?.textColor = UIColor.whiteColor()
        
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        cell!.selectedBackgroundView = selectedBackgroundView
        cell!.selectedBackgroundView.addSubview(labelName)
        cell!.selectedBackgroundView.addSubview(labelLocation)
        cell!.selectedBackgroundView.addSubview(imagePic)
        
      }

    }
    
    // println(cell!.textLabel?.text)
    return cell!
  }
  
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    println("Selected row: \(indexPath.row)")
    
    if (indexPath.row == selectedMenuItem) {
      return
    }
    
    selectedMenuItem = indexPath.row
    
    //Present new view controller
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var destViewController : UIViewController!
    switch (indexPath.row) {
    case 0:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
      break
    case 1:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
      break
//    case 2:
//      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
//      break
    case 2:
      let bookMyShowAPIFetchViewController: UIStoryboard = UIStoryboard(name: "BookMyShow",bundle: nil)
      destViewController = bookMyShowAPIFetchViewController.instantiateViewControllerWithIdentifier("BookMyShowAPIFetchViewController") as! BookMyShowAPIFetchViewController

      
      break
    case 3:
      let hotelStoryboard: UIStoryboard = UIStoryboard(name: "Hotel",bundle: nil)
      destViewController = hotelStoryboard.instantiateViewControllerWithIdentifier("HotelStoryboard") as! HotelListViewController
      
      break
    
    case 4:
      let goIbiboShowAPIFetchViewController: UIStoryboard = UIStoryboard(name: "Goibibo",bundle: nil)
      destViewController = goIbiboShowAPIFetchViewController.instantiateViewControllerWithIdentifier("CarouselViewController") as! CarouselViewController
      
      
      break
    case 5:
      let chatStoryboard: UIStoryboard = UIStoryboard(name: "Chat",bundle: nil)
      destViewController = chatStoryboard.instantiateViewControllerWithIdentifier("ConnectivityViewController") as! ConnectivityViewController
      
      

      
      break
    case 6:
      let tweetStoryboard: UIStoryboard = UIStoryboard(name: "Tweet",bundle: nil)
      destViewController = tweetStoryboard.instantiateViewControllerWithIdentifier("TwitterViewController") as! TwitterViewController
      break
    case 7:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FeedBackViewController") as! FeedBackViewController
      
      break

//    case 8:
//      
//      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ContactViewController") as! ContactViewController
//      break
//    case 9:
//      let goIbiboShowAPIFetchViewController: UIStoryboard = UIStoryboard(name: "Goibibo",bundle: nil)
//      destViewController = goIbiboShowAPIFetchViewController.instantiateViewControllerWithIdentifier("CarouselViewController") as! CarouselViewController
//      break

    default:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FeedBackViewController") as! FeedBackViewController
      break
    }
    sideMenuController()?.setContentViewController(destViewController)
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */
  
}
