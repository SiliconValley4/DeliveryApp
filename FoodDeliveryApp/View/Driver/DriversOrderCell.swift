//
//  DriversOrderCell.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit

class DriversOrderCell: UITableViewCell {
    
    @IBOutlet weak var lbRestaurantName: UILabel!
    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var lbCustomerAddress: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        imgCustomerAvatar.clipsToBounds = true
        imgCustomerAvatar.layer.cornerRadius = imgCustomerAvatar.bounds.height/2
    }

}
