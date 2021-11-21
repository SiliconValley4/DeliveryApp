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
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func configure() {
        mealPrice.layer.cornerRadius = mealPrice.bounds.height/2
        mealImg.layer.cornerRadius = 36
        
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 36
    }

}
