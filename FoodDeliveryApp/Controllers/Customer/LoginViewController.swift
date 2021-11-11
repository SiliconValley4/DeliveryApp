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
    
    //Switching User
    @IBOutlet weak var switchUser: UISegmentedControl!
    
    
    var fbLoginSuccess = false
    
    var userType: String = USER_TYPE_CUSTOMER


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil {
            bLogout.isHidden = false
            FBManager.getFBUserData(compleationHandler: {
                self.bLogin.setTitle("Continue as \(User.currenUser.email!)", for: .normal)
                //self.loginFBButton.sizeToFit()
            } )
            //self.bLogin.sendActions(for: .touchUpInside)
        } else {
            self.bLogout.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (AccessToken.current != nil && fbLoginSuccess == true) {
            userType = userType.capitalized
            performSegue(withIdentifier: "\(userType)View", sender: self)
        }
        
    }

   

    
    //Login Action
    
    @IBAction func loginFacebookButton(_ sender: Any) {
        if (AccessToken.current != nil ) {

            APIManager.shared.login(userType: userType, completitionHandler: {
                (error) in
                if error == nil {
                    self.fbLoginSuccess = true
                    self.viewDidAppear(true)
                }

            })

//            fbLoginSuccess = true
//            self.viewDidAppear(true)
        }else {
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
                
                self.bLogout.isHidden =  true
                self.bLogin.setTitle("Login with Facebook", for: .normal)
            }
        }
    }
    
    
    
    
    @IBAction func switchAccount(_ sender: Any) {
        let type = switchUser.selectedSegmentIndex
        
        if type == 0 {
            userType = USER_TYPE_CUSTOMER
        }else {
            userType = USER_TYPE_DRIVER
        }
    }
    
    
    
  
    
//END
    
}
