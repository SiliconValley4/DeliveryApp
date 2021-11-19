//
//  PaymentViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
import Stripe
import SwiftyJSON

class PaymentViewController: UIViewController {

    
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("On Payment View Controller")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    @IBAction func placeOrder(_ sender: Any) {
        print("_________________________PlaceOrderButton from Payment View Controller_________________________")
        //print("_________________________placeOrder -> getLatestOrder_______")
        APIManager.shared.getLatestOrder { (json) in
            
            //print(json)
            let orderStatus = json["order"]["status"].string! as? String ?? nil
            
            print("previous order status: \(json["order"]["status"]), may be NIL if no prev order")
            
//            if json["order"]["status"] as? String == nil || json["order"]["status"] as? String == "Delivered" {
            if orderStatus == "Delivered" || orderStatus == nil{

//            if  json["order"]["status"] == "Delivered" || json["order"]["total"] == nil{
                // Processing the payment and create an Order
                print("________________Order can be placed________________")
                //let card = self.cardTextField.cardParams
                //let card: STPCardParams = STPCardParams()
                
                let card: STPCardParams = STPCardParams()
//                card.number = self.cardTextField!.cardNumber
//                card.expMonth = UInt(self.cardTextField!.expirationMonth)
//                card.expYear = UInt(self.cardTextField!.expirationYear)
//                card.cvc = self.cardTextField!.cvc
                card.number = "4242424242424242"
                card.expMonth = 12
                card.expYear = 22
                card.cvc = "123"
                
                //print("________________Create Stripe Token________________")
                STPAPIClient.shared.createToken(withCard: card, completion: { (token, error) in
                    //print("____________Card Token: \(token!)__________")
                    
                    if let myError = error {
                        print("My Error:", myError)
                    } else if let stripeToken = token {
                        //print("____________Token Created no errors__________")
                        //print(token)
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId) { (json) in
                            //Cart.currentCart.reset()
                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                        }
                        print("_________________________Order Successfully Created_______")
                    }
                })
            
            } else {
                // Showing an alert message.
                print("Place Order Error")
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                let okAction = UIAlertAction(title: "Go to order", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "ViewOrder", sender: self)
                })
                
                let alertView = UIAlertController(title: "Already Order?", message: "Your current order isn't completed", preferredStyle: .alert)
                
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
}
