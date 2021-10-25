//
//  RegisterVC.swift
//  DeliveryApp
//
//  Created by Orlando Vargas on 10/24/21.
//

import UIKit

class RegisterVC: UIViewController {
    
    var titleLabel = SVTitleLabel(textAlignment: .center, fontSize: 46)
    var subTitleLabel = SVBodyLabel(textAlignment: .center)
    var nameField = SVTextField(placeholder: Constants.Strings.Misc.name)
    var emailField = SVTextField(placeholder: Constants.Strings.Misc.email)
    var passwordField = SVTextField(placeholder: Constants.Strings.Misc.password)
    //
    var createButton = SVButton(backgroundColor: Constants.Colors.main, title: Constants.Strings.Title.create_button)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToUI()
        configureView()
    }
    
    func addViewsToUI() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(createButton)
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        titleLabel.text = Constants.Strings.Title.create_account
        subTitleLabel.text = "blah blah blah blah"
        titleLabel.textColor = Constants.Colors.main
        titleLabel.numberOfLines = 0
        subTitleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.height/8),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width/1.5),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            nameField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 46),
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            emailField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            createButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            createButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
}
