//
//  OlaApiFetchViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit

class OlaApiFetchViewController: UIViewController {

  var cabDataList: [CabDataModal] = []
  
  
  func addDummyData2 ()
  {
    RestApiManager.sharedInstance.getRandomUser2 { (json: JSON) in
      let resultsRideEstimate = json["ride_estimate"]
      for (index: String, subJson: JSON) in resultsRideEstimate {
        var rideData : RideEstimate = RideEstimate()
        rideData.travel_time_in_minutes = subJson["travel_time_in_minutes"].object as! NSNumber
        rideData.amount_min = subJson["amount_min"].object as! NSNumber
        rideData.amount_max = subJson["amount_max"].object as! NSNumber
        rideData.category = subJson["category"].object as! String
        rideData.distance = subJson["distance"].object as! NSNumber
      }
      
      let results = json["categories"]
      
      for (index: String, subJson: JSON) in results {
        var cabData : CabDataModal = CabDataModal()
        cabData.currency = subJson["currency"].object as! String
        cabData.id = subJson["id"].object as! String
        
        cabData.imageUrl = subJson["image"].object as! String
        cabData.time_unit = subJson["time_unit"].object as! String
        cabData.display_name = subJson["display_name"].object as! String
        cabData.distance = (subJson["distance"].object) as! String
        cabData.distance_unit = subJson["distance_unit"].object as! String
        cabData.eta = subJson["eta"].object as! NSNumber
        
        let url = NSURL(string: cabData.imageUrl)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        
        
        var fare_breakupData: NSArray = subJson["fare_breakup"].object as! NSArray
        for i in 0...fare_breakupData.count-1
        {
          var fareBreakUpEntity = Fare_BreakUp()
          fareBreakUpEntity.type = fare_breakupData[i]["type"] as! String
          fareBreakUpEntity.minimum_distance = fare_breakupData[i]["minimum_distance"] as! String
          fareBreakUpEntity.minimum_time = fare_breakupData[i]["minimum_time"] as! String
          fareBreakUpEntity.base_fare = fare_breakupData[i]["base_fare"] as! String
          fareBreakUpEntity.cost_per_distance = fare_breakupData[i]["cost_per_distance"] as! String
          fareBreakUpEntity.waiting_cost_per_minute = fare_breakupData[i]["waiting_cost_per_minute"] as! String
          fareBreakUpEntity.ride_cost_per_minute = fare_breakupData[i]["ride_cost_per_minute"] as! String
          cabData.fare_breakup.append(fareBreakUpEntity)
        }
        println(cabData.fare_breakup)
        self.cabDataList.append(cabData)
        
        
      }
      
      
    }

  }
  
  func addDummyData1() {
    
    RestApiManager.sharedInstance.getRandomUser1 { (json: JSON) in
      let results = json["categories"]
      
      for (index: String, subJson: JSON) in results {
            var cabData : CabDataModal = CabDataModal()
            cabData.currency = subJson["currency"].object as! String
            cabData.id = subJson["id"].object as! String
    
            cabData.imageUrl = subJson["image"].object as! String
            cabData.time_unit = subJson["time_unit"].object as! String
            cabData.display_name = subJson["display_name"].object as! String
            cabData.distance = String(format:"%f", (subJson["distance"].object as! NSNumber).doubleValue)
            cabData.distance_unit = subJson["distance_unit"].object as! String
            cabData.eta = subJson["eta"].object as! NSNumber
    
            let url = NSURL(string: cabData.imageUrl)
              let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check

        
        
            var fare_breakupData: NSArray = subJson["fare_breakup"].object as! NSArray
            for i in 0...fare_breakupData.count-1
            {
              var fareBreakUpEntity = Fare_BreakUp()
              fareBreakUpEntity.type = fare_breakupData[i]["type"] as! String
              fareBreakUpEntity.minimum_distance = fare_breakupData[i]["minimum_distance"] as! String
              fareBreakUpEntity.minimum_time = fare_breakupData[i]["minimum_time"] as! String
              fareBreakUpEntity.base_fare = fare_breakupData[i]["base_fare"] as! String
              fareBreakUpEntity.cost_per_distance = fare_breakupData[i]["cost_per_distance"] as! String
              fareBreakUpEntity.waiting_cost_per_minute = fare_breakupData[i]["waiting_cost_per_minute"] as! String
              fareBreakUpEntity.ride_cost_per_minute = fare_breakupData[i]["ride_cost_per_minute"] as! String
              cabData.fare_breakup.append(fareBreakUpEntity)
            }
            println(cabData.fare_breakup)
            self.cabDataList.append(cabData)
            
            
          }
    }
    
  }
  
  func addrideBooking()
  {
    RestApiManager.sharedInstance.getrideBookingUrl { (json: JSON) in
      var rideBooking = RideBooking()
      var jsonData : String = "\(json)"
      var data = jsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
      
      var str : NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
      
      if let dict = data
      {
        rideBooking.crn = str.valueForKey("crn") as! String
        rideBooking.driver_name = str.valueForKey("driver_name") as! String
        rideBooking.driver_number = str.valueForKey("driver_number") as! String
        rideBooking.cab_type = str.valueForKey("cab_type") as! String
        rideBooking.cab_number = str.valueForKey("cab_number") as! String
        rideBooking.car_model = str.valueForKey("car_model") as! String
        rideBooking.eta = str.valueForKey("eta") as! NSNumber
        rideBooking.driver_lat  = str.valueForKey("driver_lat") as! Float
        rideBooking.driver_lng = str.valueForKey("driver_lng") as! Float
      }

    }
  }
        //
  
  func trackRide()
  {
    RestApiManager.sharedInstance.getTrackRideUrl { (json: JSON) in
      var trackRide = TrackRide()
      var jsonData : String = "\(json)"
      var data = jsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
      
      var str : NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
      
      if let dict = data
      {
        trackRide.status = str.valueForKey("status") as! String
        trackRide.request_type = str.valueForKey("request_type") as! String
        trackRide.booking_status = str.valueForKey("booking_status") as! String
        trackRide.crn = str.valueForKey("crn") as! String
        trackRide.duration = str.valueForKey("duration") as! NSDictionary
        trackRide.distance = str.valueForKey("distance") as! NSDictionary
        trackRide.driver_lat = str.valueForKey("driver_lat") as! Float
        trackRide.driver_lng = str.valueForKey("driver_lng") as! Float
      }
      
      
    }
  }
  func cancelRide()
  {
    RestApiManager.sharedInstance.getCancelRideUrl { (json: JSON) in
      var cancelRide = CancelRide()
      var jsonData : String = "\(json)"
      var data = jsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
      
      var str : NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
      
      if let dict = data
      {
        cancelRide.status = str.valueForKey("status") as! String
        cancelRide.request_type = str.valueForKey("request_type") as! String
//        cancelRide.text = str.valueForKey("text") as! String
        if str.valueForKey("header") != nil
        {
          cancelRide.header = str.valueForKey("header") as! String
        }
      }
      
      
    }
  }

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addDummyData1()
    addDummyData2()
    addrideBooking()
    trackRide()
    cancelRide()
    // Do any additional setup after loading the view, typically from a nib.
  }
  

}
