//
//  RestaurantViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit
import Stripe

class RestaurantViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    
    @IBOutlet weak var searchRestaurant: UISearchBar!
    @IBOutlet weak var tbvRestaurant: UITableView!
    
    
    //Getting data Dictionaries
    var restaurants = [Restaurant]()
    var filterRestaurants = [Restaurant]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvRestaurant.dataSource = self
        tbvRestaurant.delegate = self
        //
        loadRestaurants()
    }
    

    func loadRestaurants() {
        APIManager.shared.getRestaurants(completionHandler: {
            (json) in
            if json != nil {
                self.restaurants = []
                if let listRest = json!["restaurants"].array {
                    for item in listRest {
                        let restaurant = Restaurant(json: item)
                        self.restaurants.append(restaurant)
                        print(restaurant)
                    }
                    self.tbvRestaurant.reloadData()
                }
            }
        })
        
        print(restaurants)
    }
    
    
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
    
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealList" {
            let controller = segue.destination as! CustomerMenuViewController
            controller.restaurant = restaurants[(tbvRestaurant.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    
    
    
    
    //Searcb Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterRestaurants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        self.tbvRestaurant.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchRestaurant.text != "" {
            return self.filterRestaurants.count
        }
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        
        let cell = tbvRestaurant.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        
        let restaurant: Restaurant
        
        if searchRestaurant.text != "" {
            restaurant = filterRestaurants[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
    
        cell.lbRestaurantName.text = restaurant.name
        cell.lbRestaurantAddress.text = restaurant.address
        cell.lbRestaurantPhone.text = restaurant.phone
        
        
        if let logoName = restaurant.logo {
            let url = "\(logoName)"
            loadImage(imageView: cell.imgRestaurantLogo, urlString: url)
        }
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
