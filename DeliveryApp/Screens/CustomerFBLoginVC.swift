//
//  CustomerFBLoginVC.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 11/1/21.
//

import UIKit
import FBSDKLoginKit

class CustomerFBLoginVC: UIViewController {

    let appTitle = SVTitleLabel(textAlignment: .center, fontSize: 42)
    let welcomeTitle = SVBodyLabel(textAlignment: .center)
    let mainLogo = UIImageView(image: .init(named: Constants.Strings.Image.customer_login))
    let loginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToUI()
        configureView()
        setUpButtons()
    }
    
    func addViewsToUI() {
        view.backgroundColor = .tertiarySystemBackground
        mainLogo.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        view.addSubview(appTitle)
        view.addSubview(welcomeTitle)
        view.addSubview(mainLogo)
    }
    
    func setUpButtons() {

    }
    
    @objc func onSubmit() {
        //MARK: Check for username field and password field before signing in.
        // Or it can be done on the network side.
        NetworkManager.shared.signIn()
        let myView = RestaurantVC()
        myView.modalPresentationStyle = .fullScreen
        
        present(myView, animated: true, completion: nil)
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onCreate() {
        let createAccountView = RegisterVC()
        
        present(createAccountView, animated: true, completion: nil)
    }
    
    func configureView() {
        appTitle.text = Constants.Strings.Title.customer_login
        welcomeTitle.text = Constants.Strings.Title.welcome_back
        NSLayoutConstraint.activate([
            appTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            appTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            appTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            appTitle.heightAnchor.constraint(equalToConstant: view.bounds.height/15),
            welcomeTitle.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: -16),
            welcomeTitle.leadingAnchor.constraint(equalTo: appTitle.leadingAnchor),
            welcomeTitle.trailingAnchor.constraint(equalTo: appTitle.trailingAnchor),
            welcomeTitle.heightAnchor.constraint(equalToConstant: view.bounds.height/17),
            mainLogo.topAnchor.constraint(equalTo: welcomeTitle.bottomAnchor, constant: -16),
            mainLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainLogo.heightAnchor.constraint(equalTo: view.widthAnchor),
            loginButton.topAnchor.constraint(equalTo: mainLogo.bottomAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 120),
            loginButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2)
        ])
    }
}
