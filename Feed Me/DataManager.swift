//
//  DataManager.swift
//  TopApps
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import Foundation

let TopAppURL = "https://itunes.apple.com/us/rss/topgrossingipadapplications/limit=25/json"

class DataManager {
  
  class func getTopAppsDataFromItunesWithSuccess(success: ((iTunesData: NSData!) -> Void)) {
    //1
    loadDataFromURL(NSURL(string: TopAppURL)!, completion:{(data, error) -> Void in
        //2
        if let urlData = data {
          //3
          success(iTunesData: urlData)
        }
    })
  }
  
  class func getTopAppsDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      //2
      let filePath = NSBundle.mainBundle().pathForResource("OlaLocal",ofType:"json")
      
      var readError:NSError?
      if let data = NSData(contentsOfFile:filePath!,
        options: NSDataReadingOptions.DataReadingUncached,
        error:&readError) {
          success(data: data)
      }
    })
  }
  
  
  class func getHotelFromFileWithSuccess(success: ((data: NSData) -> Void)) {
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      //2
      let filePath = NSBundle.mainBundle().pathForResource("HotelSearches",ofType:"json")
      
      var readError:NSError?
      if let data = NSData(contentsOfFile:filePath!,
        options: NSDataReadingOptions.DataReadingUncached,
        error:&readError) {
          success(data: data)
      }
    })
  }
  
  class func getEventDetailsFromFileWithSuccess(success: ((data: NSData) -> Void)) {
    //1
  
      //2
      let filePath = NSBundle.mainBundle().pathForResource("getEventDetailsModel",ofType:"json")
      
      var readError:NSError?
      if let data = NSData(contentsOfFile:filePath!,
        options: NSDataReadingOptions.DataReadingUncached,
        error:&readError) {
          success(data: data)
      }
  }

  
  class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    var session = NSURLSession.sharedSession()
    
    // Use NSURLSession to get data from an NSURL
    let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
      if let responseError = error {
        completion(data: nil, error: responseError)
      } else if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
          var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        } else {
          completion(data: data, error: nil)
        }
      }
    })
    
    loadDataTask.resume()
  }
    
//    class func careTeamDataFromJSON(json: JSON) -> [TeamCareDataModal] {
//        let root = json["response"]
//        
//        var careTeamlist : [TeamCareDataModal] = []
//        for checkList in root
//        {
//            let result = TeamCareDataModal(json: checkList)
////            let result = TeamCareDataModal(checkList)
//            careTeamlist.append(result)
//        }
//        return careTeamlist
//    }
//
}