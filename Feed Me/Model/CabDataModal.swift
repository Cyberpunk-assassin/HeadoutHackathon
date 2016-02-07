//
//  CabDataModal.swift
//  HospitalPatient
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import Foundation

//Data Modal for TeamCare
class CabDataModal: NSObject {
    
    //MARK: - Variables
    var currency = ""
    var display_name = ""
    var distance : String = ""
    var distance_unit = ""
    var eta : NSNumber = 0
    var fare_breakup = [Fare_BreakUp]()
    var id = ""
    var imageUrl = ""
    var time_unit = ""
    
    override init()
    {
        self.currency = ""
        self.display_name = ""
        self.distance = ""
        self.distance_unit = ""
        self.eta = 0
        self.imageUrl = ""
        self.id = ""
        self.time_unit = ""
    }
    override var description: String {
        println("currency:\(currency) \n display_name:\(display_name) \n  distance:\(distance) \n distance_unit: \(distance_unit) \n eta:\(eta) \n  id:\(id) \n imageUrl:\(imageUrl) \n time_unit:\(time_unit) \n  fare_breakup: \(fare_breakup.description)")
        
        return "currency:\(currency) display_name:\(display_name)  distance:\(distance) distance_unit: \(distance_unit) eta:\(eta)  imageUrl:\(imageUrl) time_unit:\(time_unit)  fare_breakup: \(fare_breakup.description)"
    }

    
    
    
}
