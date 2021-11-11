//
//  CartViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
import MapKit
import CoreLocation

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    
    //TableView as tbvCart
    @IBOutlet weak var tbvCart: UITableView!
        
    //cart views
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var viewPayment: UIView!
    
    //Cart labels
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelAddress: UITextField!
    @IBOutlet weak var labelMap: MKMapView!
    @IBOutlet weak var paymentButton: UIButton!
    
    let emptyCart = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //Location
    var locationManager: CLLocationManager!
    
    override func viewDidAppear(_ animated: Bool) {
        loadmeals()
        print("DIDAPPEAR")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DIDDISAPPEAR")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DIDLOAD")
        
        loadmeals()
        
        
        tbvCart.dataSource = self
        tbvCart.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func loadmeals() {
        // Empty cart / Items in cart logic


        if Cart.currentCart.items.count == 0 {
            //empty cart
            emptyCart.text = "Your tray is empty. Please select meal."
            emptyCart.sizeToFit()
            emptyCart.center = self.view.center
            emptyCart.textAlignment = NSTextAlignment.center
            self.view.addSubview(emptyCart)

        } else {
            emptyCart.isHidden = true
            self.tbvCart.isHidden = false
            self.viewTotal.isHidden = false
            self.viewAddress.isHidden = false
            self.viewMap.isHidden = false
            self.viewPayment.isHidden = false
            self.labelAddress.text = "123 Placer Holder ave."
            
            self.tbvCart.reloadData()
            self.labelTotal.text = "$\(Cart.currentCart.getTotal())"
        }
        //Show Current Location
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.labelMap.showsUserLocation = true
        }
        
        
        
        
        

    }
    
    
    
    
    //Add Payment
    
    @IBAction func addPayment(_ sender: Any) {
        if self.labelAddress.text == "" {
            let alertController = UIAlertController(title: "No Address", message: "Address is required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert) in
                self.labelAddress.becomeFirstResponder()
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else {
            Cart.currentCart.address = self.labelAddress.text
            self.performSegue(withIdentifier: "AddPayment", sender: nil)
        }
    }
    
    
    
    //Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.labelMap.setRegion(region, animated: true)
    }
    
    
    //Address Location
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let address = textField.text
        let geocoder = CLGeocoder()
        Cart.currentCart.address = address
        
        geocoder.geocodeAddressString(address!) { (placemarks, error) in
            
            if (error != nil) {
                print("Error: ", error as Any)
            }
            
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                let region = MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                
                self.labelMap.setRegion(region, animated: true)
                self.locationManager.stopUpdatingLocation()
                
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                
                self.labelMap.addAnnotation(dropPin)
            }
        }
        
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.currentCart.items.count
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvCart.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        
        let cart = Cart.currentCart.items[indexPath.row]
        cell.qtyItemLabel.text = "\(cart.qty)"
        cell.mealNameLabel.text = cart.meal.name
        cell.priceItemLabel.text = "\(cart.meal.price! * Float(cart.qty))"
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}
