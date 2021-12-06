//
//  DriversOrderViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit

class DriversOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userWelcomeLabel: UILabel!
    @IBOutlet weak var tbvDriverOrder: UITableView!
    //variables
    var orders = [DriverOrder]()
    var loadOrdersTimer = Timer()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = sender as? String
        if(destination == "AvailableOrders"){
            tabBarController?.selectedIndex = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvDriverOrder.dataSource = self
        tbvDriverOrder.delegate = self
        userWelcomeLabel.text = User.currenUser.name

    }
    override func viewWillAppear(_ animated: Bool) {
        LoadUnloadTimer(state: "setOn")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        LoadUnloadTimer(state: "setOff")

    }
    func LoadUnloadTimer(state: String){
        if(self.loadOrdersTimer.isValid && state == "setOff"){
            loadOrdersTimer.invalidate()
            
        } else if(!self.loadOrdersTimer.isValid && state == "setOn"){
            setLoadOrdersTimer()
        }
    }
    func setLoadOrdersTimer(){
        loadReadyOrders()
        if (!loadOrdersTimer.isValid){
            loadOrdersTimer = Timer.scheduledTimer(
                timeInterval: 5.0,
                target: self,
                selector: #selector(loadReadyOrders),
                userInfo: nil,
                repeats: true)
        }
    }
    @objc func loadReadyOrders() {
        print("Orders Loaded")
        APIManager.shared.getDriverOrders{(json) in
            if json != nil {
                self.orders = []
                if let  readyOrders = json["orders"].array {
                    for item in readyOrders {
                        //print(item)
                        let order = DriverOrder(json: item)
                        self.orders.append(order)
                    }
                }
                self.tbvDriverOrder.reloadData()
            }
        }
    }
    //Picking Order: Will changen to Pick uo only if close enough
    //Also allow to pick up from far away, but can only deliver to customer once order has been "Picked Up"
    private func pickOrder(orderId: Int) {
        print("____________pickOrderFunction Pressed")
        APIManager.shared.pickOrder(orderId: orderId) { (json) in
            if let status = json["status"].string {
                switch status {
                case "failed":
                    let alertView = UIAlertController(title: "Error", message: json["error"].string!, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)
                default:
                    // Showing an alert saying Success
                    let alertView = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Show my map", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "CurrentDeliverySegue", sender: "CurrentDelivery")
                    })
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriversOrderCell") as! DriversOrderCell
        let order = orders[indexPath.row]
        cell.lbRestaurantName.text = order.restaurantName
        cell.lbCustomerName.text = order.customerName
        cell.lbCustomerAddress.text = order.customerAddress
        cell.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: order.customerAvatar!)!))
        cell.imgCustomerAvatar.layer.cornerRadius = 50/2
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        self.pickOrder(orderId: order.id!)
    }


}
