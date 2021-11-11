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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    @IBAction func placeOrder(_ sender: Any) {
        print("_________________________pressed_______")
        APIManager.shared.getLatestOrder { (json) in
            print("_________________________pressed APIMANager_______")
            //if json["order"]["status"] == nil || json["order"]["status"] == "Delivered"
            if  json["order"]["status"] == "Delivered" {
                // Processing the payment and create an Order
                print("_________________________1_______")
                //let card = self.cardTextField.cardParams
                //let card: STPCardParams = STPCardParams()
                
                let card: STPCardParams = STPCardParams()
                card.number = self.cardTextField!.cardNumber
                card.expMonth = UInt(self.cardTextField!.expirationMonth)
                card.expYear = UInt(self.cardTextField!.expirationYear)
                card.cvc = self.cardTextField!.cvc
                print("____________Card Details__________")
                print(card)
                STPAPIClient.shared.createToken(withCard: card, completion: { (token, error) in
    
                //STPAPIClient.shared.createToken(withCard: card, completion: { (token, error) in
                    print("____________Card TOken__________")
                    print(token)
                    
                    if let myError = error {
                        print("My Error:", myError)
                    } else if let stripeToken = token {
                        
                        print("____________else if Card TOken__________")
                        print(token)
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId) { (json) in
                            Cart.currentCart.reset()
                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                        }
                        print("_________________________Order Successfully Created_______")
                    }
                })
            
            } else {
                // Showing an alert message.
                
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
