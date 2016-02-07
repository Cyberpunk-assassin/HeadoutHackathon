//
//  MapViewController.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, ENSideMenuDelegate, UIAlertViewDelegate {
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  @IBOutlet weak var btnSearch: UIButton!
  var locationMarker: GMSMarker!
  
//  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
  var mapTasks = MapTasks()
  
//  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant","hospital"]
  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant","hospital"]
  
  let locationManager = CLLocationManager()
  let dataProvider = GoogleDataProvider()
  
  var randomLineColor: UIColor {
    get {
      let randomRed = CGFloat(drand48())
      let randomGreen = CGFloat(drand48())
      let randomBlue = CGFloat(drand48())
      return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
  }
  
  var mapRadius: Double {
    get {
      let region = mapView.projection.visibleRegion()
      let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
      let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
      return max(horizontalDistance, verticalDistance)*0.5
    }
  }
  
  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    // 1
    mapView.clear()
    // 2
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
      for place: GooglePlace in places {
        // 3
        let marker = PlaceMarker(place: place)
        // 4
        marker.map = self.mapView
      }
    }
  }
  
  @IBAction func refreshPlaces(sender: AnyObject) {
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
    let segmentedControl = sender as! UISegmentedControl
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      mapView.mapType = kGMSTypeNormal
    case 1:
      mapView.mapType = kGMSTypeSatellite
    case 2:
      mapView.mapType = kGMSTypeHybrid
    default:
      mapView.mapType = mapView.mapType
    }
  }
  
  func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
    // 1
    let placeMarker = marker as! PlaceMarker
    
    // 2
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
      // 3
      infoView.nameLabel.text = placeMarker.place.name
      
      // 4
      if let photo = placeMarker.place.photo {
        infoView.placePhoto.image = photo
      } else {
        infoView.placePhoto.image = UIImage(named: "generic")
      }
      
      return infoView
    } else {
      return nil
    }
  }
  
  // 1
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    // 2
    if status == .AuthorizedWhenInUse {
      
      // 3
      locationManager.startUpdatingLocation()
      
      //4
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  // 5
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let location = locations.first as? CLLocation {
      // 6
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
      // 7
      locationManager.stopUpdatingLocation()
      fetchNearbyPlaces(location.coordinate)
    }
  }
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      
      //Add this line
      self.addressLabel.unlock()
      if let address = response?.firstResult() {
        let lines = address.lines as! [String]
        self.addressLabel.text = join("\n", lines)
        
        let labelHeight = self.addressLabel.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        UIView.animateWithDuration(0.25) {
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    // 1
    let googleMarker = mapView.selectedMarker as! PlaceMarker
    
    // 2
    dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate) {optionalRoute in
      if let encodedRoute = optionalRoute {
        // 3
        let path = GMSPath(fromEncodedPath: encodedRoute)
        let line = GMSPolyline(path: path)
        
        // 4
        line.strokeWidth = 4.0
        line.tappable = true
        line.map = self.mapView
        line.strokeColor = self.randomLineColor
        
        // 5
        mapView.selectedMarker = nil
      }
    }
    
    let alert = UIAlertView(title: "", message: "Are You sure You want to book the Cab?", delegate:self, cancelButtonTitle:"No", otherButtonTitles: "Yes")
    alert.tag = 111
    alert.show()

    
  }
  
  func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
    addressLabel.lock()
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
  
  func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
    reverseGeocodeCoordinate(position.target)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    mapView.delegate = self
    self.sideMenuController()?.sideMenu?.delegate = self
    mapView.bringSubviewToFront(btnSearch)
    
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Types Segue" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = segue.destinationViewController.topViewController as! TypesTableViewController
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
  }
  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = sorted(controller.selectedTypes)
    dismissViewControllerAnimated(true, completion: nil)
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  
  // MARK: - ENSideMenu Delegate
  func sideMenuWillOpen() {
    println("sideMenuWillOpen")
  }
  
  func sideMenuWillClose() {
    println("sideMenuWillClose")
  }
  
  func sideMenuShouldOpenSideMenu() -> Bool {
    println("sideMenuShouldOpenSideMenu")
    return true
  }
  @IBAction func btnSearchTapped(sender: AnyObject) {
    
    let addressAlert = UIAlertController(title: "Address Finder", message: "Type the address you want to find:", preferredStyle: UIAlertControllerStyle.Alert)
    
    addressAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Address?"
    }
    
    let findAction = UIAlertAction(title: "Find Address", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
      let address = (addressAlert.textFields![0] as! UITextField).text as String
      
      self.mapTasks.geocodeAddress(address, withCompletionHandler: { (status, success) -> Void in
        if !success {
          println(status)
          
          if status == "ZERO_RESULTS" {
            self.showAlertWithMessage("The location could not be found.")
          }
        }
        else {
          let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
          self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 14.0)
          
//          self.setupLocationMarker(coordinate)
        }
      })
      
    }
    
    let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    addressAlert.addAction(findAction)
    addressAlert.addAction(closeAction)
    
    presentViewController(addressAlert, animated: true, completion: nil)
    
    
  }
  
  func alertView(alertView: UIAlertView,
    clickedButtonAtIndex buttonIndex: Int)
  {
    
    if alertView.tag == 111 {
      
      if buttonIndex == 1 {
        var cabHistoryViewController : CabDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CabDetailsViewController") as! CabDetailsViewController
        self.navigationController?.pushViewController(cabHistoryViewController, animated: false)

      }
    }
  }

  
  
  
  // MARK: Custom method implementation
  
  func showAlertWithMessage(message: String) {
    let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      
    }
    
    alertController.addAction(closeAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
}

