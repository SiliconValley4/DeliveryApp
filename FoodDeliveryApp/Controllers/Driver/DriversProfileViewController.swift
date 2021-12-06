//
//  DriversProfileViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/7/21.
//

import UIKit

class DriversProfileViewController: UIViewController {
    
    
    @IBOutlet weak var driversAvatar: UIImageView!
    @IBOutlet weak var lbLastName: UILabel!
    @IBOutlet weak var lbFirstName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUserProfile()
        configure()
    }
    
    func configure() {
        driversAvatar.clipsToBounds = true
        driversAvatar.layer.cornerRadius = driversAvatar.bounds.height/2
    }
    
    func configureUserProfile() {
        let fullName = User.currenUser.name!
        let components = fullName.components(separatedBy: " ")
        
        lbFirstName.text = components.first
        lbLastName.text = components.last
        
        lbEmail.text = User.currenUser.email
        
        //TODO: Split the name
        
        driversAvatar.image = try! UIImage(data: Data (contentsOf: URL(string: User.currenUser.pictureURL!)!))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DriverLogout" {
//            APIManager.shared.logout(completionHandler:{ (error) in
//                if error == nil {
                    FBManager.shared.logOut()
                    User.currenUser.resetInfo()
                    print("logggin out")
//                }
                
//            })
            
        }
    }
}
