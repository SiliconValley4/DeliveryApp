//
//  ProfileViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lbFirstName: UILabel!
    @IBOutlet weak var lbLastName: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var signoutActionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fullName = User.currenUser.name!
        userEmailLabel.text = User.currenUser.email
        
        let components = fullName.components(separatedBy: " ")
        
        lbFirstName.text = components.first
        lbLastName.text = components.last
        
        imgAvatar.image = try! UIImage(data: Data (contentsOf: URL(string: User.currenUser.pictureURL!)!))
        
        imgAvatar.layer.cornerRadius = imgAvatar.bounds.height/2
        signoutActionButton.layer.cornerRadius = 16
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerLogout" {
//            APIManager.shared.logout(completionHandler:{ (error) in
//                if error == nil {
                    FBManager.shared.logOut()
                    User.currenUser.resetInfo()
//                    print("logggin out")
//                }
                
//            })
        }
    }
    
    @IBAction func signoutAction(_ sender: Any) {
        FBManager.shared.logOut()
        User.currenUser.resetInfo()
        self.dismiss(animated: true, completion: nil)
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
