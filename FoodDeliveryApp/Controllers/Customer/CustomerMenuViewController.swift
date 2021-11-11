//
//  CustomerMenuViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit

class CustomerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restaurant: Restaurant?
    var meals = [Meal]()
    
    
    @IBOutlet weak var tbvMenu: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvMenu.dataSource = self
        tbvMenu.delegate = self
        
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurantName
        }
        
        //Run Fuctions
        loadMeals()

        // Do any additional setup after loading the view.
    }
    
    
    func loadMeals() {
        if let restaurantId = restaurant?.id {
            APIManager.shared.getMeals(resturantId: restaurantId, completionHandler: {(json) in
                if json != nil {
                    self.meals = []
                    
                    if let tempMeals = json?["meals"].array {
                        for item in tempMeals {
                            let meal = Meal(json: item)
                            self.meals.append(meal)
                        }
                        self.tbvMenu.reloadData()
                    }
                }
            })
        }
    }
    
    
    //Load Images
    func loadImage(imageView: UIImageView, urlString: String) {
        let imgUrl:URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imgUrl) {
            (data, response, error) in
            guard let data = data, error == nil else {return}
            
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
        }.resume()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        
        let meal = meals[indexPath.row]
        cell.mealName.text = meal.name
        cell.mealDescription.text = meal.short_description
        
        if let price = meal.price {
            cell.mealPrice.text = "$\(price)0"
        }
        
        if let image = meal.image {
            loadImage(imageView: cell.mealImg, urlString: "\(image)")
        }
        
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MealDetails" {
            let controller = segue.destination as! MealDetailViewController
            controller.meal = meals[(tbvMenu.indexPathForSelectedRow?.row)!]
            controller.restaurant = restaurant
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
