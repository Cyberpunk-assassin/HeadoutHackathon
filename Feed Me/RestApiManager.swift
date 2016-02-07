//
//  RestApiManager.swift
//  devdactic-rest
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
  static let sharedInstance = RestApiManager()
  var baseURL1 = "http://sandbox-t.olacabs.com/v1/products?pickup_lat=13.0350041&pickup_lng=77.6235413&category=sedan"
  var baseURL2 = "http://sandbox-t.olacabs.com/v1/products?pickup_lat=12.950072&pickup_lng=77.642684&drop_lat=13.039308&drop_lng=77.599994&category=sedan"
  var rideBookingUrl = "http://sandbox-t.olacabs.com/v1/bookings/create?pickup_lat=12.950072&pickup_lng=77.642684&pickup_mode=NOW&category=sedan"
  var trackRide = "http://sandbox-t.olacabs.com/v1/bookings/track_ride"
  var cancelRide = "http://sandbox-t.olacabs.com/v1/bookings/cancel?crn"
  
  func getRandomUser1(onCompletion: (JSON) -> Void) {
    let route = baseURL1
    makeHTTPGetRequest(route, onCompletion: { json, err in
      onCompletion(json as JSON)
    })
  }
  func getRandomUser2(onCompletion: (JSON) -> Void) {
    let route = baseURL2
    makeHTTPGetRequest(route, onCompletion: { json, err in
      onCompletion(json as JSON)
    })
  }

  func getrideBookingUrl(onCompletion: (JSON) -> Void) {
    let route = rideBookingUrl
    makeHTTPGetRequest(route, onCompletion: { json, err in
      onCompletion(json as JSON)
    })
  }
  func getTrackRideUrl(onCompletion: (JSON) -> Void) {
    let route = trackRide
    makeHTTPGetRequest(route, onCompletion: { json, err in
      onCompletion(json as JSON)
    })
  }
  func getCancelRideUrl(onCompletion: (JSON) -> Void) {
    let route = trackRide
    makeHTTPGetRequest(route, onCompletion: { json, err in
      onCompletion(json as JSON)
    })
  }

  func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
    
    
    
    let url = NSURL(string: path)
    let request = NSMutableURLRequest(URL: url!)
    
    let session = NSURLSession.sharedSession()
    request.addValue("ac4999f51ff948ca841347ce5ab3f6a9", forHTTPHeaderField: "X-APP-Token")
    request.addValue("Bearer 6a17198e474c4b2d81b0dd68aa57262a", forHTTPHeaderField: "Authorization")
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      let json:JSON = JSON(data: data)
      println(json)
      onCompletion(json, error)
    })
    task.resume()
  }
    //MARK: Perform a POST Request
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        var err: NSError?
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        // Set the POST body for the request
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, err)
        })
        task.resume()
    }
    
}