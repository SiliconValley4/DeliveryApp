//
//  Meals.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/29/21.
//

import Foundation

struct Meal: Codable {
    var id: Int
    var name: String
    var shortDescription: String
    var image: String
    var price: Double
}
