# FoodDeliveryApp

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Delivery App's purpose is to allow customers to order food from any restaurant, providing them with the option to pick-up or get their order delivered.

<img src="https://github.com/SiliconValley4/FoodDeliveryApp/blob/main/Submission/gif1-1.gif">

### App Evaluation

- **Category:** Food Delivery Application
- **Mobile:** Mobile is essential for customers to log in and track their current/past orders. Drivers must use the mobile app as well to select from list of deliveries available. Restaurant owners will use the Project website.
- **Story:** We want to facilitate local restaurants sharing their cuisine with future customers, creating jobs and growth of their communities by emphasizing the connection between restaurant owners, their customers, and delivery drivers.
- **Market:** Restaurant owners looking to expand their customer base. Customers looking to order a food delivery without the steep fees and drivers looking to make some extra cash
- **Habit:** The usage of this app would be daily, peak hours during lunch and dinner time for both drivers and customers
- **Scope:** Small to medium sized restaurants in the metropolitan area that would like to expand their customer base, outdoorsy teenagers and adults alike that like to do paid customer service, and hungry customers.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Restaurant owners will create their account using the Project website. The website will serve as the front end aspect of the restaurant owner user interface, as well as the backend for the iOS API requests.
* All interactions made in the app will be done using Project API requests.
* Customer and Driver must create an account and authenticate using their personal Facebook/Twitter account. This will add an implicit layer of security.
* Customers can select a restaurant to order from, browse their selection and make orders on demand. Pick-up is optional, Delivery is the default
* Customer will be allowed to see details of their order prior to checkout, during and upon order completion
* Drivers can select orders to deliver from their dashboard, each available delivery order includes distance information and possible earnings
* Drivers can see their net earnings data with easy to understand graphs

**Optional Nice-to-have Stories**

* User accounts can serve as both Customer and Driver
* Tip Jar for recurring drivers
* Informal chat box between customer, driver and restaurant owner

### 2. Screen Archetypes

* Welcome Page
   * User can select between customer and driver, login accordingly or create a new account
* Dashboard
   * Customer and driver dashboards are different, but they share some commonalities such as the user profile.
   * At the bottom of the screen, there is a navigation bar that allows for easy navigation between the screens.
   * Driver dashboard navigation pane includes a page to view revenue from previous delivered orders.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Customer
   * [Customer Dashboard]
   * [Profile]
   * [Current Order Status: On the way]
   * [Cart]
   * [Part Orders]


**iOS App Flow Navigation** (Screen to Screen)

* Welcome Page
   * Customer Login -> Create Account -> Customer Dashboard
   * Driver Login -> Create Account -> Customer Dashboard
* Customer Dashboard -> 
   * Restaurant List -> Meals Available -> Cart -> Checkout
   * List of meals available by selected restaurant -> Details Page
   * From Navigation Bar
      * Order Status 
      * Cart
      * Customer Profile
      * Part orders
* Driver Dashboard -> Deliveries Available -> Current Order
   * Driver Profile
   * Deliveries available
   * Previous orders
   * Revenue stats

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/SiliconValley4/FoodDeliveryApp/blob/main/Submission/flowchart.PNG">

### [BONUS] Digital Wireframes & Mockups

<img src="https://github.com/SiliconValley4/FoodDeliveryApp/blob/main/Submission/gif1-2.gif">

<!--

### [BONUS] Interactive Prototype


## Schema 
[This section will be completed in Unit 9]

### Models
[Add table of models]
### Networking

- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

-->

<img src="https://github.com/SiliconValley4/FoodDeliveryApp/blob/main/Submission/break.png">

## **Schema**
### **Models**

#### **User: Customer**

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | customerId    | Token| The token generated for the user's current session  |
   | profileImage  | List     | URL containing user profile image |
   | firstName      | String   | customerId property |
   | lastName       | String   | customerId property |
   | mobileNumber   | Number   | customerId property |
   | email          | String   | customerId property |
   | savedItems | List   | List containing all user saved meal or restaurant ids |
   | orderHistory    | List   | List containing the current user's past orders|
   | paymentStatus     | Boolean | Flag to check if new payment must be requested during checkout |
   | deliverTo     | String | contains customer address |

#### **Order**

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | orderId       | Number   | unique order identifier
   | customerId    | Token| The token generated for the user's current session  |
   | cartItems         | List     | List of key/value pairs, key for the mealId and value for the quantity |
   | deliveryFee       | Number   | Some flat or proportional rate |
   | orderTotal | Number   | Decimal value of order subtotal, taxes and fees |
   | driverId    | Number   | Identifer of driver delivering order |
   | orderMetadata     | List | contains timestamps, payment information and other order details | 

### **Networking**
#### List of network requests by screen
   - Login Screen
      - (POST) Authentication Token
         ```swift
         let path = "api/social/convert-token/"
         let url = baseURL!.appendingPathComponent(path)
         let params: [String: ANY] = [
            "grant-type": "convert-token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": AccessToken.current!.tokenString,
            "user_type": userType
         ]

         AF.request(url!, method: .post, parameters: params, encoding: JSONEnconding.default).responseJSON{
            ....
         }
         
         ```
  - Customer Dashboard
      - (GET) Retrieve List of available restaurants 
         ```swift

         let path = "api/customer/restaurants/"
         let url = baseURL?.appendingPathComponenet(path)

         AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{
            ...
         })

         ```

  - Customer Dashboard -> Select Restaurant
      - (GET) Retrieve Meals available from selected restaurant
         ```swift

         let path = "api/customer/meals/\(restaurantId)"
         let url = baseURL?.appendingPathComponent(path)

         AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{
            ...   
         })

         ```
  - Checkout -> Submit Order
      - (POST) Collect information locally and create a new order
         ```swift

         let path = "api/customer/order/add/"
         let url - baseURL?.appendingPathComponenet(path)

         let simpleArray = Cart.currentCart.items
         let jsonArray = simpleArray.map { items in
            return [
               "meal_id": item.meal.id!,
               "quantity": item.qty
            ]
         }

         if JSONSerialization.isValidJSONObject(jsonArray){
            do {
               ...
               ...
               let params: [String: Any] = [
                  "access_token":...
                  "stripe_token":....
                  "restaurant_id":....
                  "order_details":...
                  "address":...
               ]
            }
         }

         ```
  
### **Existing API Endpoints**
##### API hosted locally, not yet deployed
- Base URL - `ALLOWED_HOSTS = ['https://fooddeliverynowapp.herokuapp.com/', 'http://127.0.0.1:8000']`

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `POST`   | `api/social/convert-token` | authenticate user logged in with facebook
    `POST`   | `api/social/revoke-token` | logout user from facebook
   `POST`   | `api/social/refresh-token` | generates new token
    `GET`    | `api/customer/restaurants` | get all restaurants available to customer
    `GET`    | `api/customer/meals/<restaurant_id>` | get all the meals available from some restaurant
    `POST`    | `api/customer/order/create`  | create new order
    `POST`    | `api/customer/order/<order_id>/add`  | add to order
    `POST`    | `api/customer/order/<order_id>/seal` | finalize order, submit

<img src="https://github.com/SiliconValley4/FoodDeliveryApp/blob/main/Submission/gif2-1.gif">