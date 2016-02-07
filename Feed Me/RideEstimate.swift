//
//  RideEstimate.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class RideEstimate: NSObject {
  var travel_time_in_minutes : NSNumber = 0
  var amount_min : NSNumber = 0
  var amount_max : NSNumber = 0
  var category = ""
  var distance : NSNumber = 0
  
  override init()
  {
    self.travel_time_in_minutes = 0
    self.amount_min = 0
    self.distance = 0
    self.amount_max = 0
    self.category = ""
    self.distance = 0
  }

}
