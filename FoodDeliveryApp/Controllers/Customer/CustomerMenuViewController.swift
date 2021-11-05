//
//  CustomerMenuViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import UIKit

class CustomerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tbvMenu: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvMenu.dataSource = self
        tbvMenu.delegate = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        
        cell.textLabel?.text = "row \(indexPath.row)"
        
        return cell
    }
    
}
