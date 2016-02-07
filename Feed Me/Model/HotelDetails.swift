//
//  HotelDetails.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Ron Kliffer. All rights reserved.
//

import Foundation

class HotelDetails: NSObject
{
  var name = ""
  var address = ""
  var imageURL = ""
  var ratings = ""
  
  init(name:String, address:String, imgURL:String, rating:String)
  {
    self.name = name ?? ""
    self.address = address ?? ""
    self.ratings = rating ?? ""
    self.imageURL = imgURL ?? ""
  }
  
}