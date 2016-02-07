//
//  CabDetailsViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit
import MapKit

class CabDetailsViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

  @IBOutlet weak var lblCrn: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var lblDriverName: UILabel!
  @IBOutlet weak var lblVehichelNumber: UILabel!

  // Create a MessageComposer
  let messageComposer = MessageComposer()
  var locationDetails : NSDictionary!
  var locationManager:CLLocationManager!
  var currentLocation:CLLocation!
  var custLocations : NSMutableArray = NSMutableArray()
  var placemarkUpdate:CLPlacemark!
  
  var annotation = MKPointAnnotation()


    override func viewDidLoad() {
        super.viewDidLoad()
      lblCrn.text = ""
        self.view.userInteractionEnabled = false
        addrideBooking()
        trackRide()
      
      
      mapView.delegate = self
      mapView.showsUserLocation = true
      
      locationManager=CLLocationManager()
      locationManager.delegate = self
      locationManager.requestAlwaysAuthorization()
      locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      
      locationManager.startUpdatingLocation();
      configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func btnCancelTapped(sender: AnyObject) {
    cancelRide()
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

  @IBAction func btnCallTapped(sender: AnyObject) {
    callNumber("8123428945")
  }

  @IBAction func btnMsgTapped(sender: AnyObject) {
    // Make sure the device can send text messages
    if (messageComposer.canSendText()) {
      // Obtain a configured MFMessageComposeViewController
      let messageComposeVC = messageComposer.configuredMessageComposeViewController()
      
      // Present the configured MFMessageComposeViewController instance
      // Note that the dismissal of the VC will be handled by the messageComposer instance,
      // since it implements the appropriate delegate call-back
      presentViewController(messageComposeVC, animated: true, completion: nil)
    } else {
      // Let the user know if his/her device isn't able to send text messages
      let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
      errorAlert.show()
    }

  }
  
  
  // Call
  private func callNumber(phoneNumber:String) {
    if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
      let application:UIApplication = UIApplication.sharedApplication()
      if (application.canOpenURL(phoneCallURL)) {
        application.openURL(phoneCallURL);
      }
      else
      {
        let alert = UIAlertView()
        alert.title = "Sorry!"
        alert.message = "Phone number is not available for this business"
        alert.addButtonWithTitle("Ok")
        alert.show()
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
        self.lblCrn.text = rideBooking.crn
        rideBooking.driver_name = str.valueForKey("driver_name") as! String
        self.lblDriverName.text = rideBooking.driver_name
        rideBooking.driver_number = str.valueForKey("driver_number") as! String
        rideBooking.cab_type = str.valueForKey("cab_type") as! String
        rideBooking.cab_number = str.valueForKey("cab_number") as! String
        self.lblVehichelNumber.text = rideBooking.cab_number
        rideBooking.car_model = str.valueForKey("car_model") as! String
        
        rideBooking.eta = str.valueForKey("eta") as! NSNumber
        rideBooking.driver_lat  = str.valueForKey("driver_lat") as! Float
        rideBooking.driver_lng = str.valueForKey("driver_lng") as! Float
      }
      
    }
  }

  
  
  
  
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
        if str.valueForKey("crn") != nil
        {
          trackRide.crn = str.valueForKey("crn") as! String
        }
        
        
        trackRide.duration = str.valueForKey("duration") as! NSDictionary
        trackRide.distance = str.valueForKey("distance") as! NSDictionary
        self.lblCrn.text = trackRide.crn

        trackRide.driver_lat = str.valueForKey("driver_lat") as! Float
        trackRide.driver_lng = str.valueForKey("driver_lng") as! Float
        self.currentLocation = CLLocation(latitude: Double(trackRide.driver_lat), longitude: Double(trackRide.driver_lng))
        self.mapView.reloadInputViews()
        
      }
      self.view.userInteractionEnabled = true
      
    }
  }

  
  func configureView() {
    locationManager=CLLocationManager()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    locationManager.startUpdatingLocation();
    //currentLocation = CLLocation(latitude: 37.331789, longitude: -122.029620)
    
    var longitudeValue: Double = 12.950074
    var latitudeValue: Double = 77.641727
    currentLocation = CLLocation(latitude: latitudeValue, longitude: longitudeValue)
    
    var latitude:CLLocationDegrees = currentLocation.coordinate.latitude
    var longitude:CLLocationDegrees = currentLocation.coordinate.latitude
    
    var spanlat:CLLocationDegrees=0.015
    var spanlong:CLLocationDegrees=0.015
    
    var span:MKCoordinateSpan=MKCoordinateSpanMake(spanlat, spanlong);
    
    var location:CLLocationCoordinate2D=CLLocationCoordinate2DMake(latitude,longitude)
    
    var region:MKCoordinateRegion=MKCoordinateRegionMake(location, span)
    
    self.mapView.setRegion(region, animated:true)
    
    annotation.coordinate = location
    mapView.addAnnotation(annotation)
    self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    
    latitude = currentLocation.coordinate.latitude
    longitude = currentLocation.coordinate.longitude
    
    
    span = MKCoordinateSpanMake(spanlat, spanlong);
    
    location = CLLocationCoordinate2DMake(latitude,longitude)
    
    region = MKCoordinateRegionMake(location, span)
    
    self.mapView.setRegion(region, animated:true)
    zoomToUserLocationInMapView(self.mapView)
    
  }
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    let reuseId="annotation"
    
    var annotationNew = MKPointAnnotation()
    
    var custom = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
    custom = MKAnnotationView(annotation: annotationNew, reuseIdentifier: reuseId)
    //custom = CustomAnnotation(annotation: annotation, reuseIdentifier: reuseId)
    
    custom.canShowCallout=false
    custom.annotation=annotationNew
    var view = CustomView(frame : CGRectMake(0, 0, 30, 40))
    view.backgroundColor = UIColor.clearColor()
    
    
    //        if (currentLocation.coordinate.latitude == 12.933740189995227 && currentLocation.coordinate.longitude == 77.61455302932563)
    //        {
    custom.image = UIImage(named: "sedan")
    
    //        }
    custLocations.addObject(custom)
    
    return custom
    
  }
  
  
  func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
    var geocoder:CLGeocoder = CLGeocoder()
    let location = "1 Infinity Loop, Cupertino, CA"
    
    geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
      
      if((error) != nil){
        
        println("Error", error)
      }
      else if let placemark = placemarks?[0] as? CLPlacemark {
        
        var placemark:CLPlacemark = placemarks[0] as! CLPlacemark
        self.placemarkUpdate = placemark
        let locality = (placemark.locality != nil) ? placemark.locality : ""
        let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
        let administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
        let country = (placemark.country != nil) ? placemark.country : ""
        println(locality)
        println(postalCode)
        println(administrativeArea)
        println(country)
        println(placemark.thoroughfare)
        println(placemark.subThoroughfare)
        println(placemark.subLocality)
        println(placemark.subAdministrativeArea)
        println(placemark.administrativeArea)
        println(placemark.areasOfInterest)
        
        var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
        
        var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        pointAnnotation.title = "Apple HQ"
        
        self.mapView.addAnnotation(pointAnnotation)
        self.mapView.centerCoordinate = coordinates
        self.mapView.selectAnnotation(pointAnnotation, animated: true)
        
        println("Added annotation to map view")
      }
      
    })
    
  }

  func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
      mapView.setRegion(region, animated: true)
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
