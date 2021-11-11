//
//  Cart.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import Foundation

class CartItem {
    
    var meal: Meal
    var qty: Int
    
    init(meal: Meal, qty: Int) {
        self.meal = meal
        self.qty = qty
    }
}

class Cart {
    
    static let currentCart = Cart()
    
    var restaurant: Restaurant?
    var items = [CartItem]()
    var address: String?
    
    func getTotal() -> Float {
        var total: Float = 0
        
        for item in self.items {
            total = total + Float(item.qty) * item.meal.price!
        }
        
        return total
    }
    
    func reset() {
        self.restaurant = nil
        self.items = []
        self.address = nil
    }
}
