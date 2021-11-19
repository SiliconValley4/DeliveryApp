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
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lbStatus: UILabel!
    
    //
    var cart = [JSON]()
    
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
    var driverPin: MKPointAnnotation!
    var timer = Timer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvOrder.dataSource = self
        tbvOrder.delegate = self
        
        
        //getLatestOrder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLatestOrder()
    }
    

    func getLatestOrder() {
        
        print("Get Latest Order from Order View Controller")

        APIManager.shared.getLatestOrder { (json) in
            let order = json["order"]
            //print(json)
            print("order status:\(json["order"]["status"].string!)")

            if json["order"]["status"].string != nil {
                print("There is a previous order")
                if let orderDetails = order["order_details"].array {
                    self.lbStatus.text = order["status"].string!
                    self.cart = orderDetails
                    self.tbvOrder.reloadData()
                }
                let from = order["restaurant"]["address"].string!
                let to = order["address"].string!
                print("order from:\(json["order"]["restaurant"]["address"].string!)")
                print("order to:\(json["order"]["address"].string!)")

                
                self.getLocation(from, "RES", { (sou) in
                    self.source = sou
                    
                    self.getLocation(to, "CUS", { (des) in
                        self.destination = des
                        self.getDirections()
                    })
                })
                //if order["status"].string! != "Delivered" {
                if order["status"].string! == "On the way" {
                    //getDriverLocation(self)
                    self.setTimer()
                }
            } else {
                print("No prev order")
                self.lbStatus.text = "No previous orders"
            }
        }
    }
        

    
    // change to repeats: true to update driver location
    func setTimer() {
        getDriverLocation(self)
        timer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(getDriverLocation(_:)),
            userInfo: nil, repeats: true)
        print("Timer Called: Start")
    }
    
    func autoZoom() {
        
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
    
    
    //
    @objc func getDriverLocation(_ sender: AnyObject) {
        print("Get Driver Location from OrderViewController")
        APIManager.shared.getDriverLocation { (json) in
            print(json)
            if let location = json["location"].string {
                print(location)
                
                //self.lbStatus.text = "ON THE WAY"
                let split = location.components(separatedBy: ",")
                print(split)
                let lat = split[0]
                let lng = split[1]
                
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lng)!)
                
                // Create pin annotation for Driver
                if self.driverPin != nil {
                    self.driverPin.coordinate = coordinate
                } else {
                    self.driverPin = MKPointAnnotation()
                    self.driverPin.coordinate = coordinate
                    self.driverPin.title = "DRI"
                    self.map.addAnnotation(self.driverPin)
                }
                
                // Reset zoom rect to cover 3 locations
                self.autoZoom()
                
            } else {
                self.timer.invalidate()
                print("Timer Stopped")
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
    
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
        print("getLocation started")
        let geocoder = CLGeocoder()
        print(geocoder)
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            if (error != nil) {
                print("Get Location error")
                print("Error in geolocation: \(error!)")
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
            case "DRI":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            case "RES":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_restaurant")
            case "CUS":
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
        cell.orderItemPriceLabel.text = "$\(String(item["sub_total"].float!))"
        
        return cell
    }
    
  //End

}
