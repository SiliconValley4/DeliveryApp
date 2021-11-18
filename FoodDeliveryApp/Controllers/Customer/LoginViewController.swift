//
//  LoginViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var bLogin: UIButton!
    @IBOutlet weak var bLogout: UIButton!
    @IBOutlet weak var backSplashUI: UIView!
    
    //Switching User
    @IBOutlet weak var switchUser: UISegmentedControl!
    
 
    

    
    
    
    var fbLoginSuccess = false
    
    var userType: String = USER_TYPE_CUSTOMER


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("***********\n**********\n*********")
        
        if AccessToken.current != nil {
            bLogout.isHidden = false
            print("about to call getFBUserData from LoginVC")
            FBManager.getFBUserData(compleationHandler: {
                self.bLogin.setTitle("Continue as \(User.currenUser.email!)", for: .normal)
                //self.loginFBButton.sizeToFit()
                print("in LoginVC")
            } )
            //self.bLogin.sendActions(for: .touchUpInside)
        } else {
            self.bLogout.isHidden = true
        }
        configure()
        
    }
    
    func configure() {
        bLogin.layer.cornerRadius = bLogin.bounds.height/2
        
        backSplashUI.layer.cornerRadius = 36
        backSplashUI.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("LoginVC didAppear")
        
//        print(defaults.value(forKey: "accessToken"))
//        print(defaults.value(forKey: "refreshToken")
//        print(defaults.value(forKey: "timeLeft")
//        print(defaults.value(forKey: "expirationDate")
        
        
        if (AccessToken.current != nil && fbLoginSuccess == true) {
            userType = userType.capitalized
            performSegue(withIdentifier: "\(userType)View", sender: self)

        }
        
    }

    //Login Action
    
    @IBAction func loginFacebookButton(_ sender: Any) {
        print(AccessToken.current!)
        if (AccessToken.current != nil ) {
//            print("loginButton from LoginVC access token is not NIL")
//            let expDate = defaults.value(forKey: "expirationDate")
//            let expiresIn = Int((expDate! as AnyObject).timeIntervalSinceNow) / 60
//            print(expiresIn)
//
//            let expInt = Int((expDate as! Date).timeIntervalSinceNow) / 60
//            print("Minutes left = \(expInt)")
//
//            if( expInt > 60) { // Token is active for an hour or longer
//                print("Access and Refresh Tokens have \(expInt) minutes left to expire")
//                defaults.set(expInt, forKey: "timeLeft")
//                self.fbLoginSuccess = true
//                self.viewDidAppear(true)
//
//            } else {
//                APIManager.shared.login(userType: userType, completitionHandler: {
//                    (error) in
//                    if error == nil {
//                        self.fbLoginSuccess = true
//                        self.viewDidAppear(true)
//                    }
//
//                })
//
//            }
            APIManager.shared.login(userType: userType, completitionHandler: {
                (error) in
                if error == nil {
                    self.fbLoginSuccess = true
                    self.viewDidAppear(true)
                }

            })

        } else {
            print("loginButton from LoginVC access token is NULL")
            FBManager.shared.logIn(
                permissions: ["public_profile", "email"],
                from: self,
                handler: {(result, error ) in
                    if (error == nil ) {
                        FBManager.getFBUserData(compleationHandler: {
                            APIManager.shared.login(userType: self.userType, completitionHandler: {
                                (error) in
                                if error == nil {
                                    self.fbLoginSuccess = true
                                    self.viewDidAppear(true)
                                }

                            })

                        })

                    }
                }
            )
        }
    }
    
    
    
    @IBAction func logoutFacebookButton(_ sender: Any) {
        
        APIManager.shared.logout { (error) in
            if error == nil {
                FBManager.shared.logOut()
                User.currenUser.resetInfo()
                print("loggin out")
                
                
                self.bLogout.isHidden =  true
                self.bLogin.setTitle("Login with Facebook", for: .normal)
            }
        }
    }
    
    
    
    
    @IBAction func switchAccount(_ sender: Any) {
        let type = switchUser.selectedSegmentIndex
        
        if type == 0 {
            userType = USER_TYPE_CUSTOMER
        } else {
            userType = USER_TYPE_DRIVER
        }
    }
    
//END
    
}
