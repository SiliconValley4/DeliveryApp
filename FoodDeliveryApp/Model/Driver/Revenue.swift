//
//  Revenue.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 12/7/21.
//

import Foundation
import SwiftyJSON

class DriverRevenue {
    
    var tuesday: Int?
    var sunday: Int?
    var friday: Int?
    var saturday: Int?
    var wednesday: Int?
    var thursday: Int?
    var monday: Int?
    
    init(json: JSON) {
        
        self.tuesday = json["Tue"].int
        self.sunday = json["Sun"].int
        self.friday = json["Fri"].int
        self.saturday = json["Sat"].int
        self.wednesday = json["Wed"].int
        self.thursday = json["Thu"].int
        self.monday = json["Mon"].int
        
    }
}
