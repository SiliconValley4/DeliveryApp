//
//  OrderViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
import SwiftyJSON
import MapKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
   
    @IBOutlet weak var tbvOrder: UITableView!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lbStatus: UILabel!
    
    //
    var cart = [JSON]()
    
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
    var driverPin: MKPointAnnotation!
    var selfPin: MKPointAnnotation!
    var restaurantPin: MKPointAnnotation!
    
    var userLocation: CLLocationCoordinate2D!
    
    
    var updateDriverLocationTimer = Timer()
    var zoomTimer = Timer()
    var refreshTimer = Timer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvOrder.dataSource = self
        tbvOrder.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getLatestOrder()
        }
        
        map.layer.cornerRadius = 32

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("On orderView Controller")
        if(!self.refreshTimer.isValid){
            setRefreshViewControllerTimer()
        }
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.autoZoom()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func setRefreshViewControllerTimer(){
        print("setRefreshViewControllerTimer START")
        refreshTimer = Timer.scheduledTimer(
            timeInterval: 5.0,
            target: self,
            selector: #selector(refreshViewController),
            userInfo: nil,
            repeats: true)
    }
    @objc func refreshViewController(){
        self.getLatestOrder()
    }
    func getLatestOrder() {
        //print("Get Latest Order from Order View Controller")
        APIManager.shared.getLatestOrder { [self] (json) in
            let order = json["order"]
            //print(json)
            //print("order status:\(json["order"]["status"] as? String ?? "no prev orders")")
            let orderStatus = json["order"]["status"].string as? String ?? nil
            //print("order status:\(orderStatus)")
            if orderStatus != nil {
                if(orderStatus! == "Delivered"){
                    self.zoomTimer.invalidate()
                    self.updateDriverLocationTimer.invalidate()
                    statusLabel.text = "Previous Order:"
                }
                if let orderDetails = order["order_details"].array {
                    self.lbStatus.text = order["status"].string!
                    self.cart = orderDetails
                    self.tbvOrder.reloadData()
                }
                let from = order["restaurant"]["address"].string!
                let to = order["address"].string!

                self.getLocation(from, "Restaurant", { (sou) in
                    self.source = sou
                    self.getLocation(to, "You", { (des) in
                        self.destination = des
                        self.getDirections()
                    })
                })
                if orderStatus! == "On the way" {
                    statusLabel.text = "Current order:"
                    //getDriverLocation(self)
                    if(!self.zoomTimer.isValid){
                        self.setZoomTimer()
                    }
                    if(!self.updateDriverLocationTimer.isValid){
                        self.setUpdateDriverLocationTimer()
                    }
                }
            } else {
                print("No prev order")
                self.lbStatus.text = "No previous orders"
            }
        }
        //self.autoZoom()
    }
    func setZoomTimer() {
        print("SetZoomTimer START")
        //getDriverLocation(self)
        zoomTimer = Timer.scheduledTimer(
            timeInterval: 5.0,
            target: self,
            selector: #selector(autoZoom),
            userInfo: nil,
            repeats: true)
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
    
    
    // repeats: to update driver location
    func setUpdateDriverLocationTimer() {
        print("SetUpdateDriverLocationTimer START")
        //getDriverLocation(self)
        updateDriverLocationTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(getDriverLocation(_:)),
            userInfo: nil,
            repeats: true)
    }
    @objc func getDriverLocation(_ sender: AnyObject) {
        //print("Get Driver Location from OrderViewController")
        APIManager.shared.getDriverLocation { (json) in
            if let location = json["location"].string {
                print("Printing Driver Location from OrderView Controller")
                print(location)
                let split = location.components(separatedBy: ",")
                let lat = split[0]
                let lng = split[1]
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lng)!)
                //print(coordinate)
                // Create pin annotation for Driver
                if self.driverPin != nil {
                    self.driverPin.coordinate = coordinate
                } else {
                    self.driverPin = MKPointAnnotation()
                    self.driverPin.coordinate = coordinate
                    self.driverPin.title = "Driver"
                    self.map.addAnnotation(self.driverPin)
                }
                // Reset zoom rect to cover 3 locations
            } else {
                self.updateDriverLocationTimer.invalidate()
                self.zoomTimer.invalidate()
                self.map.removeAnnotation(self.driverPin)
                self.map.removeAnnotation(self.restaurantPin)
                print("Timer END")
            }
        }
    }
    //Map Function
    // #1
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("mapView Start")
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    // #2
    // When you call getLocation for each address, you add an "annotation" to the map
    // these are the pins
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            //print("Address: ************")
            //print("Address: \(placemarks?.first?.location?.coordinate)")
            //print("Address: \(placemarks?.first?.location?.description)")
            if (error != nil) {
                print("Error in geolocation: \(error!)")
            }
        
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                if(title=="Restaurant"){
                    self.restaurantPin = dropPin
                } else if(title == "You"){
                    self.userLocation = coordinates
                }
                self.map.addAnnotation(dropPin)
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
    }
    
    // #3
    func getDirections() {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.init(placemark: source!)
        request.destination = MKMapItem.init(placemark: destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            
            if error != nil {
                print("Error: ", error)
            } else {
                // Show route
                self.showRoute(response: response!)
            }
        }
        
    }
    
    // #4
    func showRoute(response: MKDirections.Response) {
        
        for route in response.routes {
            self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
        
        //
//        var zoomRect = MKMapRect.null
//        for annotation in self.map.annotations {
//            let annotationPoint = MKMapPoint(annotation.coordinate)
//            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
//            zoomRect = zoomRect.union(pointRect)
//        }
//
//        let insetWidth = -zoomRect.size.width * 0.2
//        let insetHeight = -zoomRect.size.height * 0.2
//        let insetRect = zoomRect.insetBy(dx: insetWidth, dy: insetHeight)
//
//        self.map.setVisibleMapRect(insetRect, animated: true)
        //
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "MyPin"
        
        var annotationView: MKAnnotationView?
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            
            annotationView = dequeueAnnotationView
            annotationView?.annotation = annotation
        } else {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView, let name = annotation.title! {
            switch name {
            case "Driver":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            case "Restaurant":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_restaurant")
            case "You":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_customer")
            default:
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            }
        }
        
        return annotationView
    }
    
    //Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        
        let item = cart[indexPath.row]
        cell.orderItemQuantityLabel.text = String(item["quantity"].int!)
        cell.orderItemNameLabel.text = item["meal"]["name"].string
        //cell.orderItemPriceLabel.text = "$\(String(item["sub_total"].float!))"
        cell.orderItemPriceLabel.text = (String(format: "$%.2f", item["sub_total"].float!))
        
        return cell
    }
    
  //End
    
    
}

extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

