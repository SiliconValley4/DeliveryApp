//
//  LoginViewController.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/21/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    let mainLogo = UIImageView(image: .init(named: "MainDelivery"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
    }
    
    func configureView() {
        mainLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLogo)
        
        NSLayoutConstraint.activate([
            mainLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.bounds.height/4)),
            mainLogo.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainLogo.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
