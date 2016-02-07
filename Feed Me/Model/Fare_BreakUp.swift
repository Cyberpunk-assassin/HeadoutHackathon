//
//  Fare_BreakUp.swift
//  TestLocal
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import Foundation

class Fare_BreakUp: NSObject, Printable {
    
    var type = ""
    var minimum_distance = ""
    var minimum_time = ""
    var base_fare = ""
    var cost_per_distance = ""
    var waiting_cost_per_minute = ""
    var ride_cost_per_minute = ""
//    var fare_breakup = ""
    
    //    var surcharge = []
    
    override init()
    {
        self.type = ""
        self.base_fare = ""
        self.cost_per_distance = ""
        self.minimum_distance = ""
        
        self.waiting_cost_per_minute = ""
        self.minimum_time = ""
        self.ride_cost_per_minute = ""
//        self.fare_breakup = ""
    }
    override var description: String {
        return "type:\(type) base_fare:\(base_fare)  cost_per_distance:\(cost_per_distance) minimum_distance: \(minimum_distance) waiting_cost_per_minute:\(waiting_cost_per_minute) minimum_time:\(minimum_time) ride_cost_per_minute:\(ride_cost_per_minute)"//fare_breakup:\(fare_breakup)"
    }
    
    
    
}

