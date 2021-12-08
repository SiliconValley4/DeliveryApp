//
//  RevenueViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
//import Charts

class RevenueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var revenuetbv: UITableView!
    
    var rev = [DriverRevenue]()

    
//    var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        self.loadRevenueData()

        // Do any additional setup after loading the view.
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as! UITabBarController
        let destination = sender as? String
        if(destination == "toProfile"){
            tabBarController.selectedIndex = 3
        }
   }
    
    @IBAction func onButton(_ sender: Any) {

    }
    
    
//    func loadRevenueData() {
//        APIManager.shared.getDriverRevenue { (json) in
//            if json != nil {
//                //print(json)
//                let revenue = json["revenue"]
//                print(revenue)
//
//            }
//        }
//    }
    
    @objc func loadRevenueData() {
        print("Revnue Loaded")
        APIManager.shared.getDriverRevenue{(json) in
            if json != nil {
//                print(json)
                self.rev = []
                if let driverRev = json["revenue"].array {
                    for item in driverRev {
                        print(item)
                        let revenue = DriverRevenue(json: item)
                        print(revenue)
                        self.rev.append(revenue)
                    }
                }
                self.revenuetbv.reloadData()
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverRevenueCell") as! DriverRevenueCell
        
//        let item = cart[indexPath.row]
//        cell.orderItemQuantityLabel.text = String(item["quantity"].int!)
//        cell.orderItemNameLabel.text = item["meal"]["name"].string
//        //cell.orderItemPriceLabel.text = "$\(String(item["sub_total"].float!))"
//        cell.orderItemPriceLabel.text = (String(format: "$%.2f", item["sub_total"].float!))
//
        return cell
    }
    

    

//end
}
