//
//  DriversProfileViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/7/21.
//

import UIKit

class DriversProfileViewController: UIViewController {
    
    
    @IBOutlet weak var driversAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbName.text = User.currenUser.name
        lbEmail.text = User.currenUser.email
        
        driversAvatar.image = try! UIImage(data: Data (contentsOf: URL(string: User.currenUser.pictureURL!)!))
        configure()
    }
    
    func configure() {
        driversAvatar.clipsToBounds = true
        driversAvatar.layer.cornerRadius = driversAvatar.bounds.height/2
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
