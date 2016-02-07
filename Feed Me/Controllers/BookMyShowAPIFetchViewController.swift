//
//  BookMyShowAPIFetchViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class BookMyShowAPIFetchViewController: UIViewController, UITableViewDelegate {
  
  var eventDataList: [EventDetails] = []
  var selectedIndex : NSIndexPath!
  //  var eventDateList: [EventDate] = []
  
  @IBOutlet weak var bookMyShowTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(animated: Bool) {
//    super.viewWillAppear(true)
    
    eventDataList = []
    DataManager.getEventDetailsFromFileWithSuccess { (data) -> Void in
      let json = JSON(data: data)
      if let eventArray = json["eventsDetails"].array{
        for i in 0...(eventArray.count-1) {
          var language : String? = eventArray[i]["Language"].string
          var eventTitle : String? = eventArray[i]["EventTitle"].string
          var censor : String? = eventArray[i]["Censor"].string
          var ratings : String? = eventArray[i]["Ratings"].string
          var showDateDisplay : String? = eventArray[i]["ShowDateDisplay"].string
          var date : String? = eventArray[i]["EventReleaseDate"].string
          var bannerURL : String? = eventArray[i]["BannerURL"].string
          var actors : String? = eventArray[i]["Actors"].string
          var genre : String? = eventArray[i]["Genre"].string
          var director : String? = eventArray[i]["Director"].string

          
          // dateDict["ShowDateDisplay"].string
          
          //          var eventDateList: [EventDate] = []
          //
          //          let dateArray = json["eventsDetails"][0]["arrDates"][0] //            .array {
          ////            for dateDict in dateArray {
          //              var showDateDisplay : String? = dateArray  // dateDict["ShowDateDisplay"].string
          //              var dates = EventDate(showDateDisplay: showDateDisplay!)
          ////              eventDateList.append(dates)
          //
          ////            }
          //
          ////          }
          var events = EventDetails(language: language!, title: eventTitle!, censor: censor!, ratings: ratings!, dateArr: showDateDisplay!, date : date!, bannerURL :bannerURL!, actors : actors!, genre : genre!, director : director! )
          //          println(eventDateList)
          
          self.eventDataList.append(events)
        }
        self.bookMyShowTableView.reloadData()
        
      }
      
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventDataList.count
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BookMyShowTableViewCell {
    
    var cell : BookMyShowTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BookMyShowTableViewCell
    cell.timeStamp.text = self.eventDataList[indexPath.row].valueForKey("ShowDateDisplay") as? String
    cell.showName.text = self.eventDataList[indexPath.row].valueForKey("EventTitle") as? String
    cell.showDetail.text = "Premiere" + " | " + (self.eventDataList[indexPath.row].valueForKey("Language") as? String)!
    cell.date.text = self.eventDataList[indexPath.row].valueForKey("Date") as? String

    var cellBckgrndImageView = UIImageView(frame: cell.frame)
    if (indexPath.row == 0){
      cellBckgrndImageView.image = UIImage(named: "ticket1")
    }
    else if(indexPath.row%2 == 0 && indexPath.row != 0){
      cellBckgrndImageView.image = UIImage(named: "ticket3")

    }
    else{
      cellBckgrndImageView.image = UIImage(named: "ticket2")

    }
    cell.backgroundView = cellBckgrndImageView
    return cell
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    selectedIndex = indexPath
    performSegueWithIdentifier("goToShowDetails", sender: self)
    
  }

  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    if segue.identifier == "goToShowDetails"{
      let controller = segue.destinationViewController as! ShowDetailViewControllrViewController
      controller.selectedIndex = self.selectedIndex
      controller.eventDataList = self.eventDataList
      controller.picURL = self.eventDataList[selectedIndex.row].valueForKey("BannerURL") as! String
      controller.actors = self.eventDataList[selectedIndex.row].valueForKey("Actors") as! String
      controller.genre = self.eventDataList[selectedIndex.row].valueForKey("Genre") as! String
      controller.director = self.eventDataList[selectedIndex.row].valueForKey("Director") as! String


    }
    
  }
  
  
}
