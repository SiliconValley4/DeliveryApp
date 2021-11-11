//
//  Constants.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/4/21.
//

import Foundation

//let CLIENT_ID = "9f1WCfAnSKtS8emLfVydlGicGHal5gNbQY21NgbD"
//let CLIENT_SECRET = "evMeguSrXxZddARxWM4wuatDEcH3ufxnnTU6rlX0SiyXQCWgVLrD5PpMIgfA8ObqNFiXVWJxWCEaYniMbHNZdBXE2fg31ZwVYMHlGMDw8xwSDj0OihSGhuxSf37ghgUG"

//let CUSTOMER = "customer"
//let DRIVER = "driver"

//let STRIPE_PUBLIC_KEY = "pk_test_51HrVG3I0pSVz7qhzEY2QqtUIEExOLgxPUNg6DCif6ioIXwD5bkzGazpkgCr8vxf2CR3ALwgsUCDzArymDdUIZ00E00H73KAHLA"

// MARK: Orlando
struct APIConstants {
    struct URL {
        static let BASE_URL: String = "https://fooddeliverynowapp.herokuapp.com/"
    }
    
    struct Client {
        static let ID = "9f1WCfAnSKtS8emLfVydlGicGHal5gNbQY21NgbD"
        static let SKEY = "evMeguSrXxZddARxWM4wuatDEcH3ufxnnTU6rlX0SiyXQCWgVLrD5PpMIgfA8ObqNFiXVWJxWCEaYniMbHNZdBXE2fg31ZwVYMHlGMDw8xwSDj0OihSGhuxSf37ghgUG"
    }
    
    struct Stripe {
        static let PKEY = "pk_test_51HrVG3I0pSVz7qhzEY2QqtUIEExOLgxPUNg6DCif6ioIXwD5bkzGazpkgCr8vxf2CR3ALwgsUCDzArymDdUIZ00E00H73KAHLA"
    }
}
