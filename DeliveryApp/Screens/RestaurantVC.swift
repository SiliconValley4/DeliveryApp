//
//  RestaurantV.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/23/21.
//

import UIKit

class RestaurantVC: UIViewController, UITableViewDataSource {

    var table = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RestaurantCell()
        
        return cell
    }
    
    func configureTableView() {
        table = UITableView(frame: view.bounds)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RestaurantCell.self, forCellReuseIdentifier: "restaurantReuseID")
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
