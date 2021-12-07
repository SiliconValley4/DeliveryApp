//
//  DeliveryViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
import MapKit

class DeliveryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var lbcustomerName: UILabel!
    @IBOutlet weak var lbCustomerAddress: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var bcomplete: UIButton!
    
    let maxd = 0.0001
    let delta = 0.00001
    let simulatorFrequency = 0.00001
    
    var orderId: Int?
    var driverHasOrder: Bool = false
    var customerName: String?
    var lbMessage = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
    //map destination
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
    var locationManager: CLLocationManager!
    
    var driverPin: MKPointAnnotation!
    var restaurantPin: MKPointAnnotation!
    var customerPin: MKPointAnnotation!

    
    var driverLocation: CLLocationCoordinate2D!
    var restaurantLocation: CLLocationCoordinate2D!
    var customerLocation: CLLocationCoordinate2D!
    
    //Update location every 3 sec
    var refreshTimer = Timer()
    var zoomTimer = Timer()
    var updateDriverLocationTimer = Timer()
    var simulatorToRestaurantTimer = Timer()
    var simulatorToCustomerTimer = Timer()
    var moving = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = sender as? String
        if(destination == "AvailableOrders"){
            tabBarController?.selectedIndex = 0
        }
    }
    
    /*
     view did load
     first startRefreshTimer
        - check if there's a current order
        - reload page
     
     viewwillappear
     if(!notLocation) - set fake location
     else remain where you are
     
    if (order){
        startLocationTimer
     */

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MUST REMOVE PINS FROM CUSTOMER RESTAURANT VIEW CONTROLLER
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//            self.map.showsUserLocation = false
//        }
    
        

        if(self.driverLocation == nil){
            print("________Moving in 10 seconds___")
//            print(self.driverLocation)
//            print(self.driverLocation)
        }
        
        //Update location
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            print("2 ")
//            self.updateDriverLocationTimer = Timer.scheduledTimer(
//                timeInterval: 0.5,
//                target: self,
//                selector: #selector(self.sendDriverLocationToServer(_:)),
//                userInfo: nil,
//                repeats: true)
//        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show current Driver's location
        loadData()
        LoadUnloadTimer(timer: &refreshTimer, phase: "setOn", name:"RefreshTimer", interval: 5.0, function: #selector(loadData))
        if(orderId != -1){
            autoZoom()
            LoadUnloadTimer(timer: &zoomTimer, phase: "setOn", name:"ZoomTimer", interval: 3.0, function: #selector(autoZoom))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if(self.driverLocation == nil){
                self.setDriverLocationTo()
            }
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LoadUnloadTimer(timer: &refreshTimer, phase: "setOff", name:"RefreshTimer", interval: nil, function: nil)
        LoadUnloadTimer(timer: &zoomTimer, phase: "setOff", name:"ZoomTimer", interval: nil, function: nil)
    }
    
//    @objc func setRefreshVCTimer(){
//        print("RefreshViewControllerTimer START")
//        self.loadData()
//        self.refreshTimer = Timer.scheduledTimer(
//            timeInterval: 5.0,
//            target: self,
//            selector: #selector(loadData),
//            userInfo: nil,
//            repeats: true)
//    }
    
    func LoadUnloadTimer(timer: inout Timer, phase: String, name: String, interval: Double? = nil, function: Selector? = nil){
        if(!timer.isValid && phase == "setOn"){
            print("Started \(name)")
            timer = Timer.scheduledTimer(
                timeInterval: interval!,
                target: self,
                selector: function!,
                userInfo: nil,
                repeats: true)
        } else if(timer.isValid && phase == "setOff"){
            timer.invalidate()
            print("Stopped \(name)")
        }
    }

    @objc func sendDriverLocationToServer(_ sender: AnyObject) {
        //self.autoZoom()
        APIManager.shared.updateLocation(location: self.driverLocation) { (json) in
            //print(self.driverLocation)
            if self.driverPin != nil {
                self.driverPin.coordinate = self.driverLocation
            } else {
                self.driverPin = MKPointAnnotation()
                self.driverPin.coordinate = self.driverLocation
                self.driverPin.title = "You"
                self.map.addAnnotation(self.driverPin)
            }
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            if(!self.simulatorToRestaurantTimer.isValid && self.restaurantLocation != nil && self.map.isHidden == false){
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    print("*******************Moving to Restaurant now*******************")
                    //print("Total distance to travel dx:\(abs(self.restaurantLocation.longitude-self.driverLocation.longitude)) dy:\(abs(self.driverLocation.latitude-self.restaurantLocation.latitude))")
                    self.simulatorToRestaurantTimer = Timer.scheduledTimer(
                        timeInterval: self.simulatorFrequency,
                        target: self,
                        selector: #selector(self.moveToRestaurant),
                        userInfo: nil,
                        repeats: true)
                }
            }
        }

    }
    
    @objc func loadData() {
        APIManager.shared.getCurrentDriverOrder { (json) in
            let order = json["order"]
            if let id = order["id"].int, order["status"] == "On the way" {
                self.lbMessage.text = ""
                self.showHideMap(state: "show")
                for annotation in self.map.annotations {
                    //print(annotation)
                }
                self.orderId = id
                //print("Order id retrieved: \(self.orderId)")
                //print(order)
                let to = order["address"].string!
                let from = order["restaurant"]["address"].string!
//                let customerName = order["customer"]["name"].string!
                self.customerName = order["customer"]["name"].string!
                let customerAvatar = order["customer"]["avatar"].string!
                self.lbcustomerName.text = self.customerName
                self.lbCustomerAddress.text = from
                
                self.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: customerAvatar)!))
                self.imgCustomerAvatar.layer.cornerRadius = 50/2
                self.imgCustomerAvatar.clipsToBounds = true
                
                self.getLocation(to, "CustomerPin", { (des) in
                    self.destination = des
                    if(self.customerPin == nil) {
                        self.customerPin = MKPointAnnotation()
                        self.customerPin.coordinate = des.coordinate }
                    self.customerLocation = des.coordinate
                    //print("To destination: \(self.destinationLocation) coordinates")
                    
                    self.getLocation(from, "RestaurantPin", { (sou) in
                        self.source = sou
                        if(self.restaurantPin == nil) {
                            self.restaurantPin = MKPointAnnotation()
                            self.restaurantPin.coordinate = sou.coordinate
                        }
                        self.restaurantLocation = sou.coordinate
                        //print("From source: \(self.restaurantLocation) coordinates")
                    })
                })
                self.LoadUnloadTimer(timer: &self.updateDriverLocationTimer, phase: "setOn", name: "UpdateLocationTimer", interval: 3.0, function: #selector(self.sendDriverLocationToServer))
                //self.LoadUnloadTimer(timer: &self.zoomTimer, phase: "setOn", name: "ZoomTimer", interval: 1.0, function: #selector(self.autoZoom))
                
            } else {
                self.LoadUnloadTimer(timer: &self.updateDriverLocationTimer, phase: "setOff", name: "UpdateLocationTimer", interval: nil, function: nil)
                self.LoadUnloadTimer(timer: &self.zoomTimer, phase: "setOff", name: "ZoomTimer", interval: nil, function: nil)
                self.showHideMap(state: "hide")
                // Showing a message here
                self.lbMessage.center = self.view.center
                self.lbMessage.textAlignment = NSTextAlignment.center
                self.lbMessage.text = "You don't have any orders for delivery."
                self.lbMessage.numberOfLines = 0
                self.view.addSubview(self.lbMessage)
                self.orderId = -1
            }
        }
    }
    
    @objc func autoZoom() {
        //print("AutoZoom called")
        var zoomRect = MKMapRect.null
        for annotation in self.map.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = zoomRect.insetBy(dx: insetWidth, dy: insetHeight)
        self.map.setVisibleMapRect(insetRect, animated: true)
    }
    
    
    
    // #1 - Delegate method of MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    // #2 - Convert an address string to a location on the map
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if (error != nil) {
                print("Error: ", error as Any)
                print("error: \(error as Any)")
            }
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                self.map.addAnnotation(dropPin)
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
    }
    
    @objc func moveToRestaurant(){
        moveTo_(self.restaurantLocation, "Restaurant")
    }
    
    @objc func moveToCustomer(){
        moveTo_(self.customerLocation, "Customer")
    }
    
    func moveTo_(_ destination: CLLocationCoordinate2D,_ name: String){
        //print("****MOVING******")
        self.moving = true
        var dx = abs(self.driverLocation.longitude-destination.longitude)
        var dy = abs(self.driverLocation.latitude-destination.latitude)
        if(dx > maxd && dy > maxd){
            self.moveX(destination)
            self.moveY(destination)
            dx = abs(self.driverLocation.longitude-destination.longitude)
            dy = abs(self.driverLocation.latitude-destination.latitude)
            //print("New Location: \(self.driverLocation)")
        } else if(dx > maxd){
            self.moveX(destination)
            dx = abs(self.driverLocation.longitude-destination.longitude)
        } else if(dy > maxd){
            self.moveY(destination)
            dy = abs(self.driverLocation.latitude-destination.latitude)
        } else{
            print("___________Driver arrived to \(name)___________")
            if(name == "Restaurant"){
                self.simulatorToRestaurantTimer.invalidate()
                self.moving = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    let degreeKMToMiles = 111.111 * 0.621371
                    print("Moving to Customer now")
//                    let distanceX = abs(self.customerLocation.longitude-self.driverLocation.longitude) * degreeKMToMiles
//                    let distanceY = abs(self.driverLocation.latitude-self.customerLocation.latitude) * degreeKMToMiles
                    //print(String(format:"Total distance to travel dx: %.2f dy: %.2f",distanceX, distanceY))
                    self.simulatorToCustomerTimer = Timer.scheduledTimer(
                        timeInterval: self.simulatorFrequency,
                        target: self,
                        selector: #selector(self.moveToCustomer),
                        userInfo: nil,
                        repeats: true)
                }
            } else if (name ==  "Customer"){
                self.simulatorToCustomerTimer.invalidate()
                self.moving = false
            }
        }
    }
    
    func moveX(_ destination: CLLocationCoordinate2D){
        let dx = abs(self.driverLocation.longitude-destination.longitude)
        let rx = Double(arc4random_uniform(10)+1)
        if(dx > maxd){
            if(self.driverLocation.longitude > destination.longitude){
                self.driverLocation.longitude -= delta * rx
            } else { self.driverLocation.longitude += delta * rx }
        }
    }
    func moveY(_ destination: CLLocationCoordinate2D){
        let dy = abs(self.driverLocation.latitude-destination.latitude)
        let ry = Double(arc4random_uniform(10)+1)
        if(dy > maxd){
            if(self.driverLocation.latitude > destination.latitude){
                self.driverLocation.latitude -= delta * ry
            } else { self.driverLocation.latitude += delta * ry }
        }
    }
    //Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let location = locations.last! as CLLocation
        self.driverLocation = location.coordinate
        print("Location Manager Called, current location: 4\(location.coordinate)")
//        print("location")
//        print(location.coordinate)
        // Create pin annotation for Driver
        if driverPin != nil {
            driverPin.coordinate = self.driverLocation
        } else {
            driverPin = MKPointAnnotation()
            driverPin.coordinate = self.driverLocation
            self.map.addAnnotation(driverPin)
        }
        driverPin.title = "You"
        //All 3 locations
        var zoomRect = MKMapRect.null
        for annotation in self.map.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 10, height: 10)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insetWidth = -zoomRect.size.width //* 0.2
        let insetHeight = -zoomRect.size.height //* 0.2
        let insetRect = zoomRect.insetBy(dx: insetWidth, dy: insetHeight)
        
        self.map.setVisibleMapRect(insetRect, animated: true)
    }
    
    //Complete Order Button Action
    @IBAction func completeOrder(_ sender: Any) {
        
        if(canProceedWithOrder("CompleteOrder")){
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                APIManager.shared.compeleteOrder(orderId: self.orderId!, completionHandler: { (json) in
                    print("__________OrderCOMplete Fuction________")
                    print(json)
                    if json != nil {
                        // Stop updating driver location
//                        self.updateDriverLocationTimer.invalidate()
//                        self.locationManager.stopUpdatingLocation()
                        // Redirect driver to the Ready Orders View
                        self.map.removeAnnotation(self.restaurantPin)
                        self.map.removeAnnotation(self.customerPin)
                        self.performSegue(withIdentifier: "ViewOrdersSegue", sender: "AvailableOrders")
                    }
                })
            }
            let alertView = UIAlertController(title: "Complete Order", message: "Please hand the order to \(self.customerName) before completing", preferredStyle: .alert)
            alertView.addAction(cancelAction)
            alertView.addAction(okAction)
            
            self.present(alertView, animated: true, completion: nil)
        } else {
            print("Cannot complete order")
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel)
//            let okAction = UIAlertAction(title: "Go to order", style: .default, handler: { (action) in
//                self.performSegue(withIdentifier: "ViewOrder", sender: self)
//            })
            let alertView = UIAlertController(title: "You're not there yet", message: "Your location tells us you're not close enough to the customer's address", preferredStyle: .alert)
            //alertView.addAction(okAction)
            alertView.addAction(cancelAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func canProceedWithOrder(_ phase: String)->Bool{
        if(self.customerLocation == nil || self.restaurantLocation == nil || self.driverLocation == nil ){ return false }
        let location : CLLocationCoordinate2D
        if(phase == "CompleteOrder"){
            location = self.customerLocation
        } else if(phase == "Pickup") {
            location = self.restaurantLocation
        } else {
            return false;
        }
        let dx = abs(self.driverLocation.longitude-location.longitude)
        let dy = abs(self.driverLocation.latitude-location.latitude)
        if(dx < maxd && dy < maxd){
            return true
        }
        return false
    }
    func showHideMap(state: String){
        if(state == "show"){
            self.map.isHidden = false
            self.viewInfo.isHidden = false
            self.bcomplete.isHidden = false
        } else if(state == "hide"){
            self.map.isHidden = true
            self.viewInfo.isHidden = true
            self.bcomplete.isHidden = true
        }
    }
    func setDriverLocationTo(){
        var newLocation = CLLocationCoordinate2D.init()
        newLocation.latitude = 40.6882
        newLocation.longitude = -73.9642
        print("New Current Location set to: \(newLocation)")
        self.driverLocation = newLocation
//        let x = customerLocation.longitude
//        let y = customerLocation.latitude
        //print("Destination x=\(x) y=\(y)")
    }
}

