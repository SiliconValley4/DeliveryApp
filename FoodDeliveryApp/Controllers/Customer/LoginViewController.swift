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
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
                
        if AccessToken.current != nil {
            bLogout.isHidden = false
            FBManager.getFBUserData(compleationHandler: {
//                self.bLogin.setTitle("Continue as \(User.currenUser.email!)", for: .normal)
                self.bLogin.setTitle("Continue as \(User.currenUser.name!)", for: .normal)

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
        
        //for (key, value) in UserDefaults.standard.dictionaryRepresentation() print("\(key) = \(value) \n")
        
        print(defaults.value(forKey: "access_token"))
        print(defaults.value(forKey: "refresh_token"))
        print(defaults.value(forKey: "time_left"))
        print(defaults.value(forKey: "expiration_date"))
        print(defaults.value(forKey: "user_type"))
        
        if (AccessToken.current != nil && fbLoginSuccess == true) {
            userType = userType.capitalized
            performSegue(withIdentifier: "\(userType)View", sender: self)
        }
        
    }

    //Login Action
    
    @IBAction func loginFacebookButton(_ sender: Any) {
        print(AccessToken.current!)
        if (AccessToken.current != nil ) {
            APIManager.shared.login(user_type: userType, completitionHandler: {
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
                            APIManager.shared.login(user_type: self.userType, completitionHandler: {
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
