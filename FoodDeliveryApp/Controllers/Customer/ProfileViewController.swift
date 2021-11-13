//
//  ProfileViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userNameLabel.text = User.currenUser.name
        userEmailLabel.text = User.currenUser.email
        
        imgAvatar.image = try! UIImage(data: Data (contentsOf: URL(string: User.currenUser.pictureURL!)!))

        // Do any additional setup after loading the view.
    }
    


    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CustomerLogout" {
//
//            //
//            FBManager.shared.logOut()
//            User.currenUser.resetInfo()
//
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerLogout" {
            APIManager.shared.logout(completionHandler:{ (error) in
                if error == nil {
                    FBManager.shared.logOut()
                    User.currenUser.resetInfo()
                    print("logggin out")
                }
                
            })
            
        }
        
    }
    
    
    
    
    
    
//    if segue.identifier == "CustomerLogout" {
//        APIManager.shared.logout(completionHandler: {
//            (error) in
//            if error == nil {
//                FBManager.shared.logOut()
//                User.currenUser.resetInfo()
//                print("logggin out")
//
//                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let appController = storyboard.instantiateViewController(withIdentifier: "MainController") as! LoginViewController
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.window?.rootViewController = appController
//            }
//
//        })
//    }
    
    
    

}
