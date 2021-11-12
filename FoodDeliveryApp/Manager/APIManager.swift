//
//  APIManager.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import MapKit

class APIManager {
    static let shared = APIManager()
    
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    let userDefaults = UserDefaults.standard
    
    func checkTokens(){
        
    }
    
    
    
    //APi to login the user
    func login(userType: String, completitionHandler: @escaping (NSError?) -> Void) {
        
        print("Loging User: API Manager")
        
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id" : CLIENT_ID,
            "client_secret" : CLIENT_SECRET,
            "backend" : "facebook",
            "token" : AccessToken.current!.tokenString,
            "user_type" : userType,
        ]
        
        
//        print(JSON(params["user_type"]))
        print("________________User Type: \(params["user_type"]!)__________________________")
        //Using alamofire for the request
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print("__________________________________________")
                print(jsonData)
                
                print("Access and Refresh Tokens expire in \(jsonData["expires_in"].int! / 60) minutes")

                
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                print("Self.expired = \(self.expired)")
                print("Date Now = \(Date.now)")
                print("json expires in = \(jsonData["expires_in"])")
                
                //let expiresIn = Int(self.expired.timeIntervalSinceNow - Date.now.timeIntervalSinceNow) / 3600
                let expiresIn = Int(self.expired.timeIntervalSinceNow) / 60
                print("User access/refresh token expires in \(expiresIn) minutes")
                
                if (expiresIn > 60){
                    self.userDefaults.set(expiresIn, forKey: "timeLeft")
                    print(self.userDefaults.integer(forKey: "timeLeft"))
                    self.userDefaults.set(self.accessToken, forKey: "accessToken")
                    self.userDefaults.set(self.refreshToken, forKey: "refreshToken")
                    self.userDefaults.set(self.expired, forKey: "expirationDate")
                                          
                }
                
                print(self.expired)

                completitionHandler(nil)
                print("_______________Success___________________")
                break


            case .failure(let error):
                completitionHandler(error as NSError)
                print("________EROR______")
                break

            }
        }
        
        
    }
    
    
    
    
    //Aoi to logout the user
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "timeLeft")
        defaults.set(nil, forKey: "accessToken")
        defaults.set(nil, forKey: "refreshToken")
        
        let path = "api/social/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id" : CLIENT_ID,
            "client_secret" : CLIENT_SECRET,
            "token" : self.accessToken,
            
        ]
        
        // Alamofire for the requests
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{(response) in
            
            switch response.result {
            case .success:
                completionHandler(nil)
                break
            
            case .failure(let error):
                completionHandler(error as NSError?)
            }
        }
    }
    
    
    
    
    // shold update user defualts too when refreshing token
    
    // API to refresh the token when it's expired
    func refreshTokenIfNeed(completionHandler: @escaping () -> Void) {
        
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        if (Date() > self.expired) {
            
            AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    completionHandler()
                    break
                    
                case .failure:
                    break
                }
            })
        } else {
            completionHandler()
        }
    }
    

//    Get restaurants List
    
    func getRestaurants(completionHandler: @escaping (JSON?) -> Void){
        let path = "api/customer/restaurants/"
        let url = baseURL?.appendingPathComponent(path)
        
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                completionHandler(jsonData)
                break
                
            case .failure:
                completionHandler(nil)
                break
            }
        }
        
        print("___________________RESTAURANTS_______________________")
        
        
        
    }
    
    //    Get restaurants List
        
    func getMeals(resturantId: Int, completionHandler: @escaping (JSON?) -> Void){
        let path = "api/customer/meals/\(resturantId)"
        let url = baseURL?.appendingPathComponent(path)
            
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            }
        print("___________________MEALS______________________")
        print("_______________________________________________________")
            
            
        }
    
    
    
    
    
    //
    // Request Server function
    func requestServer(_ method: Alamofire.HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping (JSON) -> Void ) {
        print("Request Server from API Manager")
        
        let url = baseURL?.appendingPathComponent(path)
        
        //refreshTokenIfNeed {
            
            AF.request(url!, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    print("__________________________________________")
                    print(jsonData)
                    print("___________________requestServer______________________")
                    completionHandler(jsonData)
                    
                    break
                    
                case .failure:
                    //completionHandler((rawValue: JSON) )
                    break
                }
            }
        //}
        
    }
    
    
    // API - Creating new order
//    func createOrder(stripeToken: String, completionHandler: @escaping (JSON) -> Void) {
//
//        let path = "api/customer/order/add/"
//        let simpleArray = Cart.currentCart.items
//        let jsonArray = simpleArray.map { item in
//            return [
//                "meal_id": item.meal.id!,
//                "quantity": item.qty
//            ]
//        }
//
//        if JSONSerialization.isValidJSONObject(jsonArray) {
//
//            do {
//
//                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
//                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
//
//                let params: [String: Any] = [
//                    "access_token": self.accessToken,
//                    "stripe_token": stripeToken,
//                    "restaurant_id": "\(Cart.currentCart.restaurant!.id!)",
//                    "order_details": dataString,
//                    "address": Cart.currentCart.address!
//                ]
//                print("___________________URL_______________________")
//                print("_______________________________________________________")
//                print(data)
//
//                requestServer(.post, path, params, URLEncoding(), completionHandler)
//
//            }
//            catch {
//                print("JSON serialization failed: \(error)")
//            }
//        }
//    }
    
    // API - Getting the latest order (Customer)
//    func getLatestOrder(completionHandler: @escaping (JSON) -> Void) {
//
//        let path = "api/customer/order/latest/"
//        let params: [String: Any] = [
//            "access_token": self.accessToken
//        ]
//
//        print("___________________URL_______________________")
//        print("_______________________________________________________")
//        print(accessToken)
//
//        requestServer(.get, path, params, URLEncoding(), completionHandler)
//
//        print(path)
//    }

    
    
    
    
    
    
    //Creating New Order Payment
    func createOrder(stripeToken: String, completionHandler: @escaping (JSON) -> Void){
        
        print("Create Order from API Manager")

        let path = "api/customer/order/add/"
        let url = baseURL?.appendingPathComponent(path)
        print("___________________Create Order URL_______________________")
        //print("_______________________________________________________")
        //print(url!)
        let simpleArray = Cart.currentCart.items
        let jsonArray = simpleArray.map { item in
            return [
                "meal_id": item.meal.id!,
                "quantity": item.qty
            ]
        }

        if JSONSerialization.isValidJSONObject(jsonArray) {

            do {

                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!

                let params: [String: Any] = [
                    "access_token": self.accessToken,
                    "stripe_token": stripeToken,
                    "restaurant_id": "\(Cart.currentCart.restaurant!.id!)",
                    "order_details": dataString,
                    "address": Cart.currentCart.address!
                ]

                print(accessToken)
                print(stripeToken)
                print("\(Cart.currentCart.restaurant!.id!)")
                print(dataString)
                print(Cart.currentCart.address!)

                //requestServer(.post, path, params, URLEncoding(), completionHandler)

                //testing request
                AF.request(url!, method: .post,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

                    switch response.result {
                    case .success(let value):
                        let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                        completionHandler(jsonData)
                        break

                    case .failure:
                        break
                    }
                })
                // end of test request

                print("___________________CREATE ORDER_______________________")
                //print("_______________________________________________________")

            }
            catch {
                print("JSON serialization failed: \(error)")
            }
        }

    }
//
//

    //Getting latest Orders from Customer
    func getLatestOrder(completionHandler: @escaping (JSON) -> Void) {

        let path = "api/customer/order/latest/"
        let url = baseURL?.appendingPathComponent(path)
        print("__________________getLatestOrderStartAPIManager_____________")
        //print("________________________URL_______________________")
        //print("__________________________________________________")
        
        //print(url!)
        //print(String(describing: "\(url!)"))
        
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        print(accessToken)
        //requestServer(.get, path, params, URLEncoding(), completionHandler)
        //testing request
        AF.request(url!, method: .get,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)

                print("____________________________________getLatestOrderSUCCESS____________________________")
                //print(jsonData)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)

                break

            case .failure:
                print("*********getLatestOrderFAILED***********")
                print(response)
                break
            }
        })
       
    //print("__________________getLatestOrderEnd_______________")
    }





//DRIVER FUNCTIONS

    func getDriverOrders(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/orders/ready/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    
    func pickOrder(orderId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/order/pick/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "order_id": "\(orderId)",
            "access_token": self.accessToken
        ]
        print("__________PARAMS_______")
        print(orderId)
        print(accessToken)
        
        //testing request
        AF.request(url!, method: .post,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)
                break

            case .failure:
                break
            }
        })
        
        
        
        //requestServer(.post, path, params, URLEncoding(), completionHandler)
        print("______________________order poick up Success______")
    }
    
    
    // Driver Order
    func getCurrentDriverOrder(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/order/latest/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        print("__________PARAMS_______")
        print(accessToken)
        //requestServer(.get, path, params, URLEncoding(), completionHandler)
        
        //testing request
        AF.request(url!, method: .get,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)
                break

            case .failure:
                break
            }
        })
        print("______________________Driver Current Order Success______")
    }
    
    
    
    func updateLocation(location: CLLocationCoordinate2D, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/location/update/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "location": "\(location.latitude),\(location.longitude)"
        ]
        //requestServer(.post, path, params, URLEncoding(), completionHandler)
        //testing request
        AF.request(url!, method: .post,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)
                break

            case .failure:
                break
            }
        })
        print("______________________Updating Drivers Location Success______")
    }
    
    
    func getDriverLocation(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/driver/location/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        //requestServer(.get, path, params, URLEncoding(), completionHandler)
        
        //testing request
        AF.request(url!, method: .get,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)
                break

            case .failure:
                break
            }
        })
        print("______________________Driver Location______")
    }
    
    
    
    
    func compeleteOrder(orderId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/order/complete/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "order_id": "\(orderId)",
            "access_token": self.accessToken
        ]
        //requestServer(.post, path, params, URLEncoding(), completionHandler)
        
        //testing request
        AF.request(url!, method: .post,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)
                break

            case .failure:
                break
            }
        })
        print("______________________Complete Order Success______")
    }
//
    
    
    
    
    func getDriverRevenue(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/driver/revenue/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        //requestServer(.get, path, params, URLEncoding(), completionHandler)
        //testing request
        AF.request(url!, method: .get,  parameters: params, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
//                        self.accessToken = jsonData["access_token"].string!
//                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(jsonData)
                break

            case .failure:
                break
            }
        })
        print("______________________Driver Revenue______")
    }
    
    
    
    
    
    
    
    
    
    
    
//End Class APIMAnager
}
