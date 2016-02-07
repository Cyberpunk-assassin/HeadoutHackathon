//
//  ViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit


enum TravelModes: Int {
  case driving
  case walking
  case bicycling
}


class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
  
  @IBOutlet weak var viewMap: GMSMapView!
  
  @IBOutlet weak var lblInfo: UILabel!
  
  @IBOutlet weak var lblPriceEstimate: UILabel!
  
  @IBOutlet weak var btnBook: UIButton!
  
  @IBOutlet weak var btnBookLater: UIButton!
  
  var locationManager = CLLocationManager()
  
  var didFindMyLocation = false
  
  var mapTasks = MapTasks()
  
  var locationMarker: GMSMarker!
  
  var originMarker: GMSMarker!
  
  var destinationMarker: GMSMarker!
  
  var routePolyline: GMSPolyline!
  
  var markersArray: Array<GMSMarker> = []
  
  var waypointsArray: Array<String> = []
  
  var travelMode = TravelModes.driving
  
  var cabMarker : GMSMarker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    
    let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
    viewMap.camera = camera
    viewMap.delegate = self
    
    viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    findAddress("aaa")
    
    btnBook.layer.borderWidth = 1.0
    btnBook.layer.borderColor = UIColor.lightGrayColor().CGColor
    btnBook.layer.cornerRadius = 5.0
    btnBook.tintColor = UIColor.grayColor()
    btnBookLater.tintColor = UIColor.grayColor()
    btnBookLater.layer.borderWidth = 1.0
    btnBookLater.layer.borderColor = UIColor.lightGrayColor().CGColor
    btnBookLater.layer.cornerRadius = 5.0
    
    
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if !didFindMyLocation {
      let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
      viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 16.0)
      viewMap.settings.myLocationButton = true
      
      didFindMyLocation = true
    }
  }
  
  
  // MARK: IBAction method implementation
  
  @IBAction func changeMapType(sender: AnyObject) {
    let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      self.viewMap.mapType = kGMSTypeNormal
    }
    
    let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      self.viewMap.mapType = kGMSTypeTerrain
    }
    
    let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      self.viewMap.mapType = kGMSTypeHybrid
    }
    
    let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    actionSheet.addAction(normalMapTypeAction)
    actionSheet.addAction(terrainMapTypeAction)
    actionSheet.addAction(hybridMapTypeAction)
    actionSheet.addAction(cancelAction)
    
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  
  @IBAction func findAddress(sender: AnyObject) {
    
    
    let addressAlert = UIAlertController(title: "Create Route", message: "Connect locations with a route:", preferredStyle: UIAlertControllerStyle.Alert)
    
    
    addressAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Destination?"
    }
    
    
    let createRouteAction = UIAlertAction(title: "Create Route", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      if let polyline = self.routePolyline {
        self.clearRoute()
        self.waypointsArray.removeAll(keepCapacity: false)
      }
      
      var addressLabel: UILabel = UILabel()
      
      let geocoder = GMSGeocoder()
      if self.viewMap.myLocation == nil
      {
        self.showAlertWithMessage("No Network")
        return
      }
      println(self.viewMap.myLocation)
      
      var coordinate = CLLocationCoordinate2D(latitude: +12.950072, longitude: +77.642684)
      self.cabMarker = GMSMarker(position: coordinate)
      self.cabMarker.map = self.viewMap
      self.cabMarker.icon = UIImage(named: "sedan")
      
      
      
      geocoder.reverseGeocodeCoordinate(self.viewMap.myLocation.coordinate) { response , error in
        
        //Add this line
        addressLabel.unlock()
        if let address = response?.firstResult() {
          let lines = address.lines as! [String]
          addressLabel.text = join("\n", lines)
          
          let origin : String = addressLabel.text!
          
          let destination = (addressAlert.textFields![0] as! UITextField).text as String
          
          self.mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
            if success {
              self.configureMapAndMarkersForRoute()
              self.drawRoute()
              self.displayRouteInfo()
            }
            else {
              println(status)
            }
          })
        }
        
        
        
        
      }
    }
    let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    addressAlert.addAction(createRouteAction)
    addressAlert.addAction(closeAction)
    
    presentViewController(addressAlert, animated: true, completion: nil)
    
    
  }
  
  
  @IBAction func createRoute(sender: AnyObject) {
    let addressAlert = UIAlertController(title: "Create Route", message: "Connect locations with a route:", preferredStyle: UIAlertControllerStyle.Alert)
    
    addressAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Origin?"
    }
    
    addressAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Destination?"
    }
    
    
    let createRouteAction = UIAlertAction(title: "Create Route", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      if let polyline = self.routePolyline {
        self.clearRoute()
        self.waypointsArray.removeAll(keepCapacity: false)
      }
      
      let origin = (addressAlert.textFields![0] as! UITextField).text as String
      let destination = (addressAlert.textFields![1] as! UITextField).text as String
      
      self.mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
        if success {
          self.configureMapAndMarkersForRoute()
          self.drawRoute()
          self.displayRouteInfo()
        }
        else {
          println(status)
        }
      })
    }
    
    let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    addressAlert.addAction(createRouteAction)
    addressAlert.addAction(closeAction)
    
    presentViewController(addressAlert, animated: true, completion: nil)
  }
  
  
  @IBAction func changeTravelMode(sender: AnyObject) {
    let actionSheet = UIAlertController(title: "Travel Mode", message: "Select travel mode:", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let drivingModeAction = UIAlertAction(title: "Driving", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      self.travelMode = TravelModes.driving
      self.recreateRoute()
    }
    
    let walkingModeAction = UIAlertAction(title: "Walking", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      self.travelMode = TravelModes.walking
      self.recreateRoute()
    }
    
    let bicyclingModeAction = UIAlertAction(title: "Bicycling", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      self.travelMode = TravelModes.bicycling
      self.recreateRoute()
    }
    
    let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    actionSheet.addAction(drivingModeAction)
    actionSheet.addAction(walkingModeAction)
    actionSheet.addAction(bicyclingModeAction)
    actionSheet.addAction(closeAction)
    
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  
  // MARK: CLLocationManagerDelegate method implementation
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == CLAuthorizationStatus.AuthorizedWhenInUse {
      viewMap.myLocationEnabled = true
    }
  }
  
  
  // MARK: Custom method implementation
  
  func showAlertWithMessage(message: String) {
    let alertController = UIAlertController(title: "Sorry", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    alertController.addAction(closeAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  
  func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
    if locationMarker != nil {
      locationMarker.map = nil
    }
    
    locationMarker = GMSMarker(position: coordinate)
    locationMarker.map = viewMap
    
    locationMarker.title = mapTasks.fetchedFormattedAddress
    locationMarker.appearAnimation = kGMSMarkerAnimationPop
    locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
    locationMarker.opacity = 0.75
    
    locationMarker.flat = true
    locationMarker.snippet = "The best place on earth."
    
    
    
    //    cabMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: , longitude: <#CLLocationDegrees#>))
  }
  
  
  func configureMapAndMarkersForRoute() {
    viewMap.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 11.0)
    
    originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
    originMarker.map = self.viewMap
    originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
    originMarker.title = self.mapTasks.originAddress
    
    destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
    destinationMarker.map = self.viewMap
    destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
    destinationMarker.title = self.mapTasks.destinationAddress
    
    
    
    if waypointsArray.count > 0 {
      for waypoint in waypointsArray {
        let lat: Double = (waypoint.componentsSeparatedByString(",")[0] as NSString).doubleValue
        let lng: Double = (waypoint.componentsSeparatedByString(",")[1] as NSString).doubleValue
        
        let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
        marker.map = viewMap
        marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
        
        markersArray.append(marker)
      }
    }
  }
  
  
  func drawRoute() {
    let route = mapTasks.overviewPolyline["points"] as! String
    
    let path: GMSPath = GMSPath(fromEncodedPath: route)
    routePolyline = GMSPolyline(path: path)
    routePolyline.map = viewMap
  }
  
  
  func displayRouteInfo() {
    lblInfo.text = mapTasks.totalDistance + "\n" + mapTasks.totalDuration
  }
  
  
  func clearRoute() {
    originMarker.map = nil
    destinationMarker.map = nil
    routePolyline.map = nil
    
    originMarker = nil
    destinationMarker = nil
    routePolyline = nil
    
    if markersArray.count > 0 {
      for marker in markersArray {
        marker.map = nil
      }
      
      markersArray.removeAll(keepCapacity: false)
    }
  }
  
  
  func recreateRoute() {
    if let polyline = routePolyline {
      clearRoute()
      
      mapTasks.getDirections(mapTasks.originAddress, destination: mapTasks.destinationAddress, waypoints: waypointsArray, travelMode: travelMode, completionHandler: { (status, success) -> Void in
        
        if success {
          self.configureMapAndMarkersForRoute()
          self.drawRoute()
          self.displayRouteInfo()
        }
        else {
          println(status)
        }
      })
    }
  }
  
  
  // MARK: GMSMapViewDelegate method implementation
  
  //  func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
  //    if let polyline = routePolyline {
  //      let positionString = String(format: "%f", coordinate.latitude) + "," + String(format: "%f", coordinate.longitude)
  //      waypointsArray.append(positionString)
  //
  //      recreateRoute()
  //    }
  //  }
  
  @IBAction func btnMenuTapped(sender: AnyObject) {
    toggleSideMenuView()
    
  }
  @IBAction func btnBookTapped(sender: AnyObject) {
    estimatePrice()
    
  }
  @IBAction func btnBookLaterTapped(sender: AnyObject) {
    var dateAndTimeViewController : DateAndTimeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DateAndTimeViewController") as! DateAndTimeViewController
    self.presentViewController(dateAndTimeViewController, animated: true, completion: nil)
    
  }
  
  func estimatePrice ()
  {
    
    println(mapTasks.totalDistance)
    
    
    
    //      RestApiManager.sharedInstance.getRandomUser2 { (json: JSON) in
    //        let resultsRideEstimate = json["ride_estimate"]
    //        if self.lblPriceEstimate.text! == "0"
    //        {
    //          var data = [json["ride_estimate"].object as! NSArray ][0].valueForKey("amount_min")
    //          self.lblPriceEstimate.text = "\(data)"
    //        }
    //
    //        for (index: String, subJson: JSON) in resultsRideEstimate {
    //          var rideData : RideEstimate = RideEstimate()
    //          rideData.travel_time_in_minutes = subJson["travel_time_in_minutes"].object as! NSNumber
    //          rideData.amount_min = subJson["amount_min"].object as! NSNumber
    //          rideData.amount_max = subJson["amount_max"].object as! NSNumber
    //          rideData.category = subJson["category"].object as! String
    //          rideData.distance = subJson["distance"].object as! NSNumber
    //          dispatch_async(dispatch_get_main_queue()) {
    //            self.lblPriceEstimate.text = "\(rideData.amount_min)"
    //          }
    //
    //
    //        }
    //
    //        let results = json["categories"]
    //
    //        for (index: String, subJson: JSON) in results {
    //          var cabData : CabDataModal = CabDataModal()
    //          cabData.currency = subJson["currency"].object as! String
    //          cabData.id = subJson["id"].object as! String
    //
    //          cabData.imageUrl = subJson["image"].object as! String
    //          cabData.time_unit = subJson["time_unit"].object as! String
    //          cabData.display_name = subJson["display_name"].object as! String
    //          cabData.distance = (subJson["distance"].object) as! String
    //          cabData.distance_unit = subJson["distance_unit"].object as! String
    //          cabData.eta = subJson["eta"].object as! NSNumber
    //
    //          let url = NSURL(string: cabData.imageUrl)
    //          let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
    //
    //
    //          let fare_breakupData: NSArray = (subJson["fare_breakup"].object as? NSArray)!
    //          if  fare_breakupData.count > 0{
    //            for i in 0...fare_breakupData.count-1
    //            {
    //              var fareBreakUpEntity = Fare_BreakUp()
    //              fareBreakUpEntity.type = fare_breakupData[i]["type"] as! String
    //              fareBreakUpEntity.minimum_distance = fare_breakupData[i]["minimum_distance"] as! String
    //              fareBreakUpEntity.minimum_time = fare_breakupData[i]["minimum_time"] as! String
    //              fareBreakUpEntity.base_fare = fare_breakupData[i]["base_fare"] as! String
    //              fareBreakUpEntity.cost_per_distance = fare_breakupData[i]["cost_per_distance"] as! String
    //              fareBreakUpEntity.waiting_cost_per_minute = fare_breakupData[i]["waiting_cost_per_minute"] as! String
    //              fareBreakUpEntity.ride_cost_per_minute = fare_breakupData[i]["ride_cost_per_minute"] as! String
    //
    //              var calculate = (fareBreakUpEntity.base_fare as NSString).floatValue
    //              calculate = calculate + ((fareBreakUpEntity.minimum_distance as NSString).floatValue * ((fareBreakUpEntity.cost_per_distance as NSString).floatValue))
    //              calculate = calculate + (fareBreakUpEntity.waiting_cost_per_minute as NSString).floatValue * 10
    //              self.lblPriceEstimate.text = "\(calculate)"
    //
    //
    //              var cabHistoryViewController : CabDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CabDetailsViewController") as! CabDetailsViewController
    //              self.navigationController?.pushViewController(cabHistoryViewController, animated: false)
    //              //            self.presentViewController(cabHistoryViewController, animated: true, completion: nil)
    //
    //              cabData.fare_breakup.append(fareBreakUpEntity)
    //
    //          }
    //
    //
    //          }
    //          else{
    //          }
    //          println(cabData.fare_breakup)
    ////          self.cabDataList.append(cabData)
    //
    //
    //        }
    //
    //    }
    
    DataManager.getTopAppsDataFromFileWithSuccess{(data) -> Void in
      //   let resultsRideEstimate = json["ride_estimate"]
      let json = JSON(data: data)
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
        
        
        let fare_breakupData: NSArray = (subJson["fare_breakup"].object as? NSArray)!
        if  fare_breakupData.count > 0{
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
            
            var calculate = (fareBreakUpEntity.base_fare as NSString).floatValue
            calculate = calculate + ((fareBreakUpEntity.minimum_distance as NSString).floatValue * ((fareBreakUpEntity.cost_per_distance as NSString).floatValue))
            calculate = calculate + (fareBreakUpEntity.waiting_cost_per_minute as NSString).floatValue * 10
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
              //2
              self.lblPriceEstimate.text = "\(calculate)"
            })
            
            
            
            cabData.fare_breakup.append(fareBreakUpEntity)
            break
          }
          
        }
        }
        //          self.cabDataList.append(cabData)
//      var cabHistoryViewController : CabDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CabDetailsViewController") as! CabDetailsViewController
      
      
//                  self.navigationController?.pushViewController(cabHistoryViewController, animated: false)
//      self.presentViewController(cabHistoryViewController, animated: true, completion: nil)

      
    }
    
    
    
    
  }
}

