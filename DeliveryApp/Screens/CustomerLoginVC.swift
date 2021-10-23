//
//  CustomerLoginViewController.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/22/21.
//

import UIKit

class CustomerLoginVC: UIViewController {
    
    let appTitle = SVTitleLabel(textAlignment: .center, fontSize: 42)
    let welcomeTitle = SVBodyLabel(textAlignment: .center)
    let mainLogo = UIImageView(image: .init(named: Constants.Strings.Image.customer_login))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToUI()
        configureView()
    }
    
    func addViewsToUI() {
        view.backgroundColor = .tertiarySystemBackground
        mainLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appTitle)
        view.addSubview(welcomeTitle)
        view.addSubview(mainLogo)
    }
    
    func configureView() {
        appTitle.text = Constants.Strings.Title.customer_login
        welcomeTitle.text = Constants.Strings.Title.welcome_back
        NSLayoutConstraint.activate([
            appTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            appTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            appTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            appTitle.heightAnchor.constraint(equalToConstant: view.bounds.height/15),
            welcomeTitle.topAnchor.constraint(equalTo: appTitle.bottomAnchor),
            welcomeTitle.leadingAnchor.constraint(equalTo: appTitle.leadingAnchor),
            welcomeTitle.trailingAnchor.constraint(equalTo: appTitle.trailingAnchor),
            welcomeTitle.heightAnchor.constraint(equalToConstant: view.bounds.height/17),
            mainLogo.topAnchor.constraint(equalTo: welcomeTitle.bottomAnchor),
            mainLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainLogo.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
