//
//  OrderCell.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var orderItemQuantityLabel: UILabel!
    @IBOutlet weak var orderItemNameLabel: UILabel!
    @IBOutlet weak var orderItemPriceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
