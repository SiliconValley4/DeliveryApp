//
//  User.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import Foundation
import SwiftyJSON

class User {
    var name: String?
    var email: String?
    var pictureURL: String?
    
    static let currenUser = User()
    
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.email = json["email"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
        
    }
    
    func resetInfo() {
        self.name = nil
        self.email = nil
        self.pictureURL = nil
    }
    
    
    
    
}
