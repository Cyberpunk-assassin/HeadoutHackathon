//
//  HotelListViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit

class HotelListViewController: UIViewController {

  @IBOutlet weak var hotelTableView: UITableView!
  
  var hotelList : [HotelDetails] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(animated: Bool) {
    
    DataManager.getHotelFromFileWithSuccess{(data) -> Void in
      let json = JSON(data: data)
      if let resultsArray = json["results"].array{
        for i in 0...(resultsArray.count-1) {
          var name : String? = resultsArray[i]["name"].string
          var address : String? = resultsArray[i]["NewAddress"].string
          var thumbnail : String? = resultsArray[i]["thumbnail"].string
          var ratings : String? = resultsArray[i]["compRating"].string
          var hotelDetails = HotelDetails(name: name!, address: address!, imgURL: thumbnail!, rating: ratings!)
          
          self.hotelList.append(hotelDetails)
        }
        self.hotelTableView.reloadData()
        
      }
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hotelList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: HotelListTableViewCell = tableView.dequeueReusableCellWithIdentifier("hotelListCell") as! HotelListTableViewCell
    cell.name.text = self.hotelList[indexPath.row].valueForKey("name") as? String
    cell.address.text = self.hotelList[indexPath.row].valueForKey("address") as? String
    cell.rating.text = self.hotelList[indexPath.row].valueForKey("ratings") as? String
    let imgData = UIImage(data: NSData(contentsOfURL: NSURL(string: (self.hotelList[indexPath.row].valueForKey("imageURL") as? String)!)!)!)
//    cell.imageView?.frame = CGRect(x: 100, y: 10, width: 50, height: 50)
//    cell.imageView?.sizeToFit()
//    cell.imageView?.clipsToBounds = true
//    cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    cell.thumbnail?.image = imgData
    
    return cell
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
