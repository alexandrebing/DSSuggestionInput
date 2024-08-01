//
//  ViewController.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var sugestionInput: DSSuggestionInput = {
        return DSSuggestionInput(placeholder: "Type your email", dataList: self.domains.sorted())
    }()
    
    private let confirmEmailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Confirm your email"
        return textField
    }()
    
    private let domains = ["gmail.com", "yahoo.com", "outlook.com", "icloud.com", "yahoo.com.br", "hotmail.com", "msn.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sugestionInput)
        contentView.addSubview(confirmEmailTextField)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        sugestionInput.translatesAutoresizingMaskIntoConstraints = false
        confirmEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: sugestionInput.tableView.frame.height),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            sugestionInput.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200),
            sugestionInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sugestionInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmEmailTextField.topAnchor.constraint(equalTo: sugestionInput.bottomAnchor, constant: 20),
            confirmEmailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmEmailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmEmailTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            
        ])
    }
}

