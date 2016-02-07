//
//  EventDate.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import Foundation

class EventDate : NSObject {
  
  var ShowDateDisplay = ""
//  var ShowDateCode = ""
//  var EventCode = ""
  
  init(showDateDisplay: String)
  {
    self.ShowDateDisplay = showDateDisplay ?? ""
//    self.ShowDateCode = ""
//    self.EventCode = ""
  }
}