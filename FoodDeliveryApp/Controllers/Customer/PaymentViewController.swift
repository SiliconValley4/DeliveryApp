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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = sender as? String
        if(destination == "CurrentOrder"){
            tabBarController?.selectedIndex = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("On Payment View Controller")
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        print("_________________________PlaceOrderButton from Payment View Controller_________________________")
        //print("_________________________placeOrder -> getLatestOrder_______")
        APIManager.shared.getLatestOrder { (json) in
            
            //print(json)
            let orderStatus = json["order"]["status"].string ?? nil
            
            print("previous order status: \(orderStatus), may be NIL if no prev order")
            
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
                STPAPIClient.shared.createToken(withCard: card, completion: { (token, error) in
                    //print("____________Card Token: \(token!)__________")
                    if let myError = error {
                        print("My Error:", myError)
                    } else if let stripeToken = token {
                        //print("____________Token Created no errors__________")
                        //print(token)
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId) { (json) in
                            //Cart.currentCart.reset()
                            self.dismissAndGo()
                        }
                        print("_________________________Order Successfully Created_______")
                    }
                })
            } else {
                // Showing an alert message.
                print("Place Order Error")
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                let okAction = UIAlertAction(title: "Go to order", style: .default, handler: { (action) in
                    self.dismissAndGo()
                })
                let alertView = UIAlertController(title: "Already Order?", message: "Your current order isn't completed", preferredStyle: .alert)
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func dismissAndGo(){
        self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "CurrentOrderSegue", sender: "CurrentOrder")
    }
}
