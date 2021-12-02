//
//  RestaurantCell.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    
    @IBOutlet weak var imgRestaurantLogo: UIImageView!
    @IBOutlet weak var lbRestaurantName: UILabel!
    @IBOutlet weak var lbRestaurantAddress: UILabel!
    @IBOutlet weak var lbRestaurantPhone: UILabel!
    @IBOutlet weak var lbRestaurantDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgRestaurantLogo.clipsToBounds = true
        imgRestaurantLogo.layer.cornerRadius = 36
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
