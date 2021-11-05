//
//  MenuCell.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit

class MenuCell: UITableViewCell {
    
    
    @IBOutlet weak var mealImg: UIImageView!
    
    @IBOutlet weak var mealName: UILabel!
    
    @IBOutlet weak var mealDescription: UILabel!
    
    @IBOutlet weak var mealPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
