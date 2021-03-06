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
    var usertype = "Customer"

    override func viewDidLoad() {
        super.viewDidLoad()
                
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (switchUser.selectedSegmentIndex == 0){
            usertype == "Customer"
        
        } else {
            usertype == "Driver"
        }
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //for (key, value) in UserDefaults.standard.dictionaryRepresentation() print("\(key) = \(value) \n")
        print(UserDefaults.standard.value(forKey: "access_token"))
        if (AccessToken.current != nil && fbLoginSuccess == true) {
            userType = userType.capitalized
            performSegue(withIdentifier: "\(userType)View", sender: self)
        }
    }

    //Login Action
    
    @IBAction func loginFacebookButton(_ sender: Any) {
        let userView = "\(self.usertype)View"
        //print(AccessToken.current!)
        if (AccessToken.current != nil ) {
            //print("loginButton from LoginVC facebook allowed")
            APIManager.shared.login(user_type: userType, completitionHandler: {
                (error) in
                if error == nil {
                    self.sendToUserView()
                }
            })
        } else {
            //print("loginButton from LoginVC facebook access denied")
            FBManager.shared.logIn(
                permissions: ["public_profile", "email"],
                from: self,
                handler: {(result, error ) in
                    if (error == nil ) {
                        FBManager.getFBUserData(compleationHandler: {
                            APIManager.shared.login(user_type: self.userType, completitionHandler: {
                                (error) in
                                if error == nil {
                                    self.sendToUserView()
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
            print("ERROR: \(error)")
            if error != nil {
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
    
    func configure() {
        bLogin.layer.cornerRadius = bLogin.bounds.height/2
        backSplashUI.layer.cornerRadius = 36
        backSplashUI.clipsToBounds = true
    }
    
    func sendToUserView(){
        self.fbLoginSuccess = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let userView = "\(self.usertype)View"
            self.viewDidAppear(true)
            self.performSegue(withIdentifier: userView, sender: "LoginButton")
        }
    }
    

    
}
