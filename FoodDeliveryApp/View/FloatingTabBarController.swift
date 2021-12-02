//
//  FloatingTabBarController.swift
//  FoodDeliveryApp
//
//  Created by Orlando Vargas on 11/21/21.
//

import UIKit

class FloatingTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: tabBar.bounds.minY + 5, width: tabBar.bounds.width - 64, height: tabBar.bounds.height + 10), cornerRadius: 16).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.black.cgColor
        //tabBar.isTranslucent = false
      
        tabBar.layer.insertSublayer(layer, at: 0)

        if let items = self.tabBar.items {
            items.forEach { item in
                item.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
            }
        }

//        tabBar.itemWidth = 32
        //tabBar.itemPositioning = .fill
        tabBar.unselectedItemTintColor = .white
      }
}
