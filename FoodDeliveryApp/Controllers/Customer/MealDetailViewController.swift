//
//  MealDetailViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit
import Stripe

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealDescription: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet var labelIndividualCost: UILabel!
    @IBOutlet weak var reduceQtyButton: UIButton!
    @IBOutlet weak var increaseQtyButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var meal: Meal?
    var restaurant: Restaurant?
    var qty = 1
    
    @IBAction func goToCart(_ sender: Any) {
        performSegue(withIdentifier: "ViewCartSegue", sender: "ViewCart")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = sender as? String
        if(destination == "ViewCart"){
            tabBarController?.selectedIndex = 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMeal()
        // Do any additional setup after loading the view.
        configure()
    }
    
    
    func loadMeal() {
        
        if let price = meal?.price {
            lbTotal.text = "Total\n$\(price)0"
            labelIndividualCost.text = "Each\n$\(price)0"
        }
        
        
        mealName.text = meal?.name
        mealDescription.text = meal?.short_description
//        Helpers.loadImage(imgMeal, "http://cdn.sallysbakingaddiction.com/wp-content/uploads/2020/03/mini-quiches.jpg")
        
        if let imageUrl = meal?.image {
            Helpers.loadImage(mealImage, "\(imageUrl)")
            //print(imageUrl)
        }
    }
    
    private func configure() {
        mealImage.layer.cornerRadius = 32
        mealImage.clipsToBounds = true
        view.backgroundColor = .systemGray5
    
        
        labelIndividualCost.backgroundColor = .white
        lbTotal.backgroundColor = .white
        
        labelIndividualCost.layer.cornerRadius = 16
        labelIndividualCost.clipsToBounds = true
        lbTotal.layer.cornerRadius = 16
        lbTotal.clipsToBounds = true
        lbQty.clipsToBounds = true
        lbQty.layer.cornerRadius = 8
        reduceQtyButton.layer.cornerRadius = 8
        increaseQtyButton.layer.cornerRadius = 8
        addToCartButton.layer.cornerRadius = 8
        
    }
    
    
    //
    
    @IBAction func removeQty(_ sender: Any) {
        if qty >= 2 {
            qty -= 1
            lbQty.text = String(qty)
            
            if let price = meal?.price {
                lbTotal.text = "Total\n$\(price * Float(qty))0"
            }
        }
    }
    
    @IBAction func addQty(_ sender: Any) {
        if qty < 99 {
            qty += 1
            lbQty.text = String(qty)
            
            if let price = meal?.price {
                lbTotal.text = "Total\n$\(price * Float(qty))0"
            }
        }
    
    }
    
    @IBAction func addToCart(_ sender: Any) {
        print("Add to cart from restaurant: \(restaurant?.id)")
        //print("\(Cart.currentCart.restaurant)")

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
                print(Cart.currentCart.restaurant)
                print(self.restaurant)
                // If those requirements are not met
                Cart.currentCart.restaurant = self.restaurant
                Cart.currentCart.items.append(cartItem)
                print("Added item(s) to empty cart")
                self.dismiss()
                return
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in
                self.dismiss()
            }
            // If ordering meal from the same restaurant
            if cartRestaurant.id == currentRestaurant.id {
                let inCart = Cart.currentCart.items.firstIndex(where: { (item) -> Bool in
                    return item.meal.id! == cartItem.meal.id!
                })
                if let index = inCart {
                    let alertView = UIAlertController(
                        title: "Add more?",
                        message: "Your Cart already has this.",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Add more", style: .default, handler: { (action: UIAlertAction!) in
                        print("Added more of the same item")
                        Cart.currentCart.items[index].qty += self.qty
                        self.dismiss()
                    })
                    alertView.addAction(okAction)
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)
                } else {
                    print("Added something new")
                    Cart.currentCart.items.append(cartItem)
                    self.dismiss()
                }
            }
            else {// If ordering meal from the another restaurant
                print("Diff Rest")
                let alertView = UIAlertController(
                    title: "Start new Order?",
                    message: "You're ordering meal from another restaurant. Create New Order?",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "New Order", style: .default, handler: { (action: UIAlertAction!) in
                    Cart.currentCart.items = []
                    Cart.currentCart.items.append(cartItem)
                    Cart.currentCart.restaurant = self.restaurant
                    print("Item(s) added from new restaurant")
                    self.dismiss()
                })
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        })
    }
    func dismiss(){
        self.navigationController?.popViewController(animated: true)
    }

}
