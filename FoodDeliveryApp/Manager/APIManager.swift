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
    let defaults = UserDefaults.standard
    
    var accessToken = ""
    var refreshToken = ""
    var timeLeft = 0
    var expirationDate = Date()
    var tokenAvailable = false
    var userType = ""
    
    func resetUserDefaults(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }

        print("REMOVED IMPORTANT KEYS")
//        defaults.removeObject(forKey: "accessToken")
//        defaults.removeObject(forKey: "refreshToken")
//        defaults.removeObject(forKey: "timeLeft")
//        defaults.removeObject(forKey: "expirationDate")
//        defaults.removeObject(forKey: "userType")

        print(defaults.value(forKey: "accessToken"))
        print(defaults.value(forKey: "refreshToken"))
        print(defaults.value(forKey: "timeLeft"))
        print(defaults.value(forKey: "expirationDate"))
        print(defaults.value(forKey: "userType"))

    }
    
    func checkTokens() -> Bool {
        
        //resetUserDefaults()
        
        print("checking TokenStatus")
        
        print("API Global variables accessToken: \(accessToken) -- refreshToken: \(refreshToken)")
        //print("Facebook Auth token: \((AccessToken.current?.tokenString)!)\nExpires in: \((AccessToken.current?.expirationDate)!)")
        
        let fbAuthTk = (AccessToken.current?.tokenString)!
        let fbAuthTkTime = Int((AccessToken.current?.expirationDate as! Date).timeIntervalSinceNow) / (3600 * 24)
        //print("Facebook Auth token: \(fbAuthTk)\nExpires in: \(fbAuthTkTime) days")
        
//        let access_token = defaults.value(forKey: "access_token")!
//        print("access_token: \(access_token)")
//        let refresh_token = defaults.value(forKey: "refreshToken")!
//        print("rewfresh-token: \(refresh_token)")
//        let time_left = defaults.value(forKey: "timeLeft")!
//        print("Tokens time left in minutes: \(time_left)")
//        let expiration_date = defaults.value(forKey: "expirationDate")!
//        print("Tokens expiration date \(expiration_date)")
        
        if(AccessToken.isCurrentAccessTokenActive){
            
            self.timeLeft = getTokenTimeLeft()
            
            if(self.timeLeft > 59){ // Tokens have an hour left of life
                return true
            } else{
//                getNewToken(user_type: userType, completionHandler : {
//                    (error) in
//                    if error == nil {
//                    }
//                })
                return false
            }
//            // another way of displaying time Data of Facebook Access Token, unnecessary but helpful to visualize
//            let expDate = AccessToken.current?.expirationDate
//            let formatter = DateComponentsFormatter()
//            formatter.allowedUnits = [.day, .hour, .minute]
//            let timeInMinHour = formatter.string(from: Date.now, to: expDate!)
//            print("time in days hr:min = \(timeInMinHour!)")
            
//            let timeLeftHours = Int(expDate!.timeIntervalSinceNow - Date.now.timeIntervalSinceNow) / (60 * 60)
//            print("Facebook access token expires in \(timeLeftInteger) hours")
            
        }
        return false
        
    }
    
    func getTokenTimeLeft()->Int{
        // interval is given in seconds, we want to look at the minutes left
        return Int(self.expirationDate.timeIntervalSinceNow) / 60
    }
    
    func populateUserDefaults(){
        self.defaults.set(self.timeLeft, forKey: "time_left")
        self.defaults.set(self.accessToken, forKey: "access_token")
        self.defaults.set(self.refreshToken, forKey: "refresh_token")
        self.defaults.set(self.expirationDate, forKey: "expiration_date")
        self.defaults.set(self.userType, forKey: "user_type")
    }
    
    func getNewToken(){
        print("getting new token")
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id" : APIConstants.Client.ID,
            "client_secret" : APIConstants.Client.SKEY,
            "backend" : "facebook",
            "token" : AccessToken.current!.tokenString,
            "user_type" : userType,
        ]
        print("________________User Type: \(params["user_type"]!)__________________________")
        
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { [self]
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expirationDate = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                self.timeLeft = getTokenTimeLeft()
                self.userType = params["user_type"] as! String
                print("_____________________________________________________________")
                print("Token jsonData: \(jsonData)")
                print("Access and Refresh Tokens expire in \(jsonData["expires_in"].int! / 60) minutes")
                print("Self.expired = \(self.expirationDate)")
                print("Date Now = \(Date.now)")
                print("json expires in = \(jsonData["expires_in"])")
                print("_____________________________________________________________")
                

                //populateUserDefaults()

                print("_______________Success___________________")
                break

            case .failure(let error):
                print("________EROR______")
                break
            }
        }
    }
    
    func getToken(user_type: String, completitionHandler: @escaping (NSError?) -> Void){
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id" : APIConstants.Client.ID,
            "client_secret" : APIConstants.Client.SKEY,
            "backend" : "facebook",
            "token" : AccessToken.current!.tokenString,
            "user_type" : user_type,
        ]
        print("________________User Type: \(params["user_type"]!)__________________________")
        //Using alamofire for the request
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { [self]
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expirationDate = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                self.timeLeft = getTokenTimeLeft()
                self.userType = user_type
                print("_____________________________________________________________")
                print("Token jsonData: \(jsonData)")
                print("Access and Refresh Tokens expire in \(jsonData["expires_in"].int! / 60) minutes")
                print("Self.expired = \(self.expirationDate)")
                print("Date Now = \(Date.now)")
                print("json expires in = \(jsonData["expires_in"])")
                print("_____________________________________________________________")
            
                //populateUserDefaults()

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
    
    //APi to login the user
    func login(user_type: String, completitionHandler: @escaping (NSError?) -> Void) {
        
        print("Loging User: API Manager")
        
        tokenAvailable = checkTokens()
        
        if(!tokenAvailable){
            getToken(user_type: user_type, completitionHandler: completitionHandler)
        }
    }
    
    //Aoi to logout the user
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        defaults.removeObject(forKey: "accessToken")
        defaults.removeObject(forKey: "refreshToken")
        defaults.removeObject(forKey: "timeLeft")
        defaults.removeObject(forKey: "expirationDate")
        defaults.removeObject(forKey: "userType")

        let path = "api/social/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        print(url )
//        let headers : HTTPHeaders = [
//            "Content-Type" : "application/x-www-form-urlencoded"
//        ]
        let params: [String: Any] = [
            "client_id" : APIConstants.Client.ID,
            "client_secret" : APIConstants.Client.SKEY,
            "token" : self.accessToken,
        ]
        print(self.accessToken)
        // Alamofire for the requests
        AF.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON{(response) in
            
//            switch response.result {
//
//            case .success:
//                //print("__________success...__________")
//                completionHandler(nil)
//                print("__________LOGOUT SUCCESSFUL__________")
//                break
//
//            case .failure(let error):
//                completionHandler(error as NSError?)
//                //print("__________LOGOUT EROR__________")
//            }
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                completionHandler(nil)
                print("__________________________________________")
                print(jsonData)
//

            case .failure(let error):
                completionHandler(error as NSError?)
                print("Failed")
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
        
        if (Date() > self.expirationDate) {
            
            AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].string!
                    self.expirationDate = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
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
                    //"access_token": self.accessToken,
                    "access_token" : self.defaults.value(forKey: "accessToken"),
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
        
        var params: [String: Any] = [
            "access_token": self.accessToken
        ]
        print(accessToken)
        print(params)
        print(defaults.value(forKey: "accessToken")!)
        params["access_token"] = defaults.value(forKey: "accessToken")!
        print(params)
        
        
        
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
