//
//  SVConstants.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/22/21.
//

import UIKit

struct Constants {
    
    struct Strings {
        struct Title {
            static var app_title: String = "Delivery App"
            static var welcome_back: String = "Welcome Back!"
            static var customer_login: String = "Customer Login"
            static var create_account: String = "Create Customer Account"
            static var create_button: String = "Create Account"
        }
        
        struct Misc {
            static var needAccount: String = "Need an account?"
            static var password: String = "Password"
            static var email: String = "Email"
            static var name: String = "Name"
        }
        
        struct Image {
            static var entry_scooter: String = "main_delivery"
            static var customer_login: String = "customer_login"
        }
        
        struct Button {
            static var customer: String = "Customer"
            static var driver: String = "Driver"
            static var signIn: String = "Sign In"
            static var cancel: String = "Cancel"
            
            static var createAccount: String = "Create one"
        }
    }
    
    struct Colors {
        static let main = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 1)
    }
}
