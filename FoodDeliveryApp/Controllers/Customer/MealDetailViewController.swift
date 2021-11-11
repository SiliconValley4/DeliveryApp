//
//  MealDetailViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit
import Stripe

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealDescription: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet var labelIndividualCost: UILabel!
    
    var meal: Meal?
    var restaurant: Restaurant?
    var qty = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMeal()
        // Do any additional setup after loading the view.
    }
    
    
    func loadMeal() {
        //
        if let price = meal?.price {
            lbTotal.text = "Total:\n$\(price)"
            labelIndividualCost.text = "Each:\n$\(price)"
        }
        
        
        mealName.text = meal?.name
        mealDescription.text = meal?.short_description
        
        //if let imageUrl = meal?.image {
            //Helpers.loadImage(imgMeal, "\(imageUrl)")
            Helpers.loadImage(imgMeal, "https://media-cdn.tripadvisor.com/media/photo-s/0d/dd/93/0d/pizza-con-pollo-pepperoni.jpg")
        //}
        
    }
    
    
    
    
    //
    
    @IBAction func removeQty(_ sender: Any) {
        if qty >= 2 {
            qty -= 1
            lbQty.text = String(qty)
            
            if let price = meal?.price {
                lbTotal.text = "Total:\n$\(price * Float(qty))"
            }
        }
    }
    
    @IBAction func addQty(_ sender: Any) {
        if qty < 99 {
            qty += 1
            lbQty.text = String(qty)
            
            if let price = meal?.price {
                lbTotal.text = "Total:\n$\(price * Float(qty))"
            }
        }
    
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        image.image = UIImage(named: "")
        image.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-100)
        self.view.addSubview(image)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { image.center = CGPoint(x: self.view.frame.width - 40, y: 24) },
                       completion: { _ in
                        
            image.removeFromSuperview()
            
            let cartItem = CartItem(meal: self.meal!, qty: self.qty)
                        
            guard let cartRestaurant = Cart.currentCart.restaurant, let currentRestaurant = self.restaurant else {
                // If those requirements are not met
                
                Cart.currentCart.restaurant = self.restaurant
                Cart.currentCart.items.append(cartItem)
                return
            }
                        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
               
            // If ordering meal from the same restaurant
            if cartRestaurant.id == currentRestaurant.id {
                
                let inCart = Cart.currentCart.items.firstIndex(where: { (item) -> Bool in
                    
                    return item.meal.id! == cartItem.meal.id!
                })
                
                if let index = inCart {
                    
                    let alertView = UIAlertController(
                        title: "Add more?",
                        message: "Your Cart already has this meal. Add more?",
                        preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Add more", style: .default, handler: { (action: UIAlertAction!) in
                        
                        Cart.currentCart.items[index].qty += self.qty
                    })
                    
                    alertView.addAction(okAction)
                    alertView.addAction(cancelAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                } else {
                    Cart.currentCart.items.append(cartItem)
                }
            
            }
            else {// If ordering meal from the another restaurant
            
                let alertView = UIAlertController(
                    title: "Start new Order?",
                    message: "You're ordering meal from another restaurant. Create New Order?",
                    preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "New Order", style: .default, handler: { (action: UIAlertAction!) in
                    
                    Cart.currentCart.items = []
                    Cart.currentCart.items.append(cartItem)
                    Cart.currentCart.restaurant = self.restaurant
                })
                
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
        })
        
        print("Added items to cart")
    }
    
    
    
    
    

 

}
