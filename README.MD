# DeliveryApp

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Delivery App's purpose is to allow customers to order food from any restaurant, providing them with the options to pick-up or get their order delivered.

<img src="https://github.com/SiliconValley4/DeliveryApp/blob/main/Submission/gif.gif">

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Food Delivery Application
- **Mobile:** Mobile is essential for customers to log in and track their current/past orders. Drivers must use mobile app as well to select deliveries available. Restaurant owners will use the webpage.
- **Story:** We want to allow local restaurants to share their cuisine with future customers, creating jobs and facilitating the growth of communities by creating a connection between restaurant owners, their customers, and the delivery drivers.
- **Market:** Only restaurant owners can register their restaurant upon submission of required credentials. No current custome restrictions.
- **Habit:** The usage of this app would be daily, peak hours during lunch and dinner time for both drivers and customers
- **Scope:** Small to medium sized restaurants in the metropolitan area that would like to expand their customer base 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Restaurant owners will create their account using the Project website. The website will serve as the front end aspect of the restaurant owner user interface, as well as the backend for the iOS API requests.
* All interactions made in the app will be done using Project API requests.
* Customer and Driver must create an account and authenticate using their personal Facebook/Twitter account. This will add an implicit layer of security.
* Customers can select a restaurant to order from, browse their selection and make orders on demand. Pick-up is optional, Delivery is the default
* Customer will be allowed to see details of their order prior to checkout, during and upon order completion
* Drivers can select orders to deliver from their dashboard, each available delivery order includes distance information and possible earnings
* Drivers can see their net earnings data with easy to read and understand graphs

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


** iOS App Flow Navigation** (Screen to Screen)

* Welcome Page
   * Customer Login -> Create Account
   * Driver Login -> Create Account
* Customer Dashboard
   * Restaurant List
   * List of meals available by selected restaurant -> Details Page
   * From Navigation Bar
      * Order Status
      * Cart
      * Customer Profile
      * Part orders
* Driver Dashboard
   * Driver Profile
   * Deliveries available
   * Previous orders
   * Revenue stats

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/SiliconValley4/DeliveryApp/blob/main/Submission/flowchart.PNG">

### [BONUS] Digital Wireframes & Mockups

<img src="https://github.com/SiliconValley4/DeliveryApp/blob/main/Submission/gif2.gif">

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
