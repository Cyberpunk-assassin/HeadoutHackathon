//
//  EventDetails.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import Foundation

class EventDetails: NSObject {
  var Language = ""
  var EventTitle = ""
  var Censor = ""
  var Ratings = ""
  var ShowDateDisplay = ""
  var Date = ""
  var BannerURL = ""
  var Actors = ""
  var Genre = ""
  var Director = ""
  
  init(language : String, title:String, censor:String, ratings:String, dateArr: String , date :String, bannerURL:String, actors : String, genre:String, director :String)
  {
    self.Language = language ?? ""
    self.EventTitle = title ?? ""
    self.Censor = censor ?? ""
    self.Ratings = ratings ?? ""
    self.ShowDateDisplay = dateArr ?? ""
    self.Date = date ?? ""
    self.BannerURL = bannerURL ?? ""
    self.Actors = actors ?? ""
    self.Genre = genre ?? ""
    self.Director = director ?? ""
  }
  
}

