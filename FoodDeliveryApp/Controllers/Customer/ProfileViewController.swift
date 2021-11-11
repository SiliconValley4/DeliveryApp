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
    


    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerLogout" {
            
            //
            FBManager.shared.logOut()
            User.currenUser.resetInfo()
        }
    }

}
