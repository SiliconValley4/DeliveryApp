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
    let emailTextField = SVTextField(placeholder: Constants.Strings.Misc.email)
    let passwordTextField = SVTextField(placeholder: Constants.Strings.Misc.password)
    let signInButton = SVButton(backgroundColor: Constants.Colors.main, title: Constants.Strings.Button.signIn)
    let cancelButton = SVButton(backgroundColor: .gray, title: Constants.Strings.Button.cancel)
    let createAccountButton = SVButton(backgroundColor: .clear, title: Constants.Strings.Misc.needAccount)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToUI()
        configureView()
        setUpButtons()
    }
    
    func addViewsToUI() {
        view.backgroundColor = .tertiarySystemBackground
        mainLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appTitle)
        view.addSubview(welcomeTitle)
        view.addSubview(mainLogo)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(cancelButton)
    }
    
    func setUpButtons() {
        signInButton.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
    }
    
    @objc func onSubmit() {
        //MARK: Check for username field and password field before signing in.
        // Or it can be done on the network side.
        NetworkManager.shared.signIn()
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
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
            mainLogo.heightAnchor.constraint(equalTo: view.widthAnchor),
            emailTextField.topAnchor.constraint(equalTo: mainLogo.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            signInButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
