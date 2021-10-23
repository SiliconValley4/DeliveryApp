//
//  LoginViewController.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/21/21.
//

import UIKit

class LoginVC: UIViewController {
    
    let mainLogo = UIImageView(image: .init(named: Constants.Strings.Image.entry_scooter))
    let appTitle = SVTitleLabel(textAlignment: .center, fontSize: 42)
    let loginButton = SVButton(backgroundColor: Constants.Colors.main, title: Constants.Strings.Button.customer)
    let driverButton = SVButton(backgroundColor: .systemGray, title: Constants.Strings.Button.driver)

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToUI()
        configureView()
        configureButtonAction()
    }
    
    //
    @objc func onCustomerButton() {
        let viewToBePresented = CustomerLoginVC()
        viewToBePresented.modalPresentationStyle = .fullScreen
        
        present(viewToBePresented, animated: true, completion: nil)
    }
    
    @objc func onDriverButton() {
        
    }
    
    func addViewsToUI() {
        view.addSubview(mainLogo)
        view.addSubview(appTitle)
        view.addSubview(loginButton)
        view.addSubview(driverButton)
    }
    
    func configureButtonAction() {
        loginButton.addTarget(self, action: #selector(onCustomerButton), for: .touchUpInside)
        driverButton.addTarget(self, action: #selector(onDriverButton), for: .touchUpInside)
    }
    
    func configureView() {
        view.backgroundColor = .tertiarySystemBackground
        appTitle.text = Constants.Strings.Title.app_title
        mainLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.bounds.height/5)),
            mainLogo.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainLogo.heightAnchor.constraint(equalTo: view.widthAnchor),
            appTitle.topAnchor.constraint(equalTo: mainLogo.bottomAnchor, constant: -64),
            appTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            appTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            appTitle.heightAnchor.constraint(equalToConstant: view.bounds.height/15),
            loginButton.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: view.bounds.height/15),
            driverButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            driverButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            driverButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            driverButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor)
        ])
    }
}
