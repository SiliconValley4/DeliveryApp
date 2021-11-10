//
//  NetworkManager.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/24/21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let BaseURL = "https://endpoint_here"
    //let cache = NSCache<Any, Any>()
    
    private init() {} // Doesn't allowed mulitple instances. (Like a singleton in java)
    
    // You might need to pass in the password and username
    func signIn() {
        //MARK: Sign in code here
    }
    
    func signOut() {
        //MARK: Signout code here
    }
    
    // Current Location
    func getRestaurants() {
        
    }
    
    // Pass in restaurants ID
    func getMealsForRestaurants() {
        
    }
}
