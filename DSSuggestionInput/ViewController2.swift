//
//  ViewController2.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit

class ViewController2: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let emailInputView: DSTextInput = {
        let emailInputView = DSTextInput(placeholder: "Enter your email")
        return emailInputView
    }()
    
    private let confirmEmailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Confirm your email"
        return textField
    }()
    
    private lazy var tableView: DSSuggestionListTableView = {
        let tableView = DSSuggestionListTableView(dataList: domains)
        return tableView
    }()
    
    private let domains = ["gmail.com", "yahoo.com", "outlook.com", "icloud.com"]
    private var filteredDomains: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupBinds()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBlue
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailInputView)
        contentView.addSubview(confirmEmailTextField)
        view.addSubview(tableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        emailInputView.translatesAutoresizingMaskIntoConstraints = false
        confirmEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            emailInputView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200),
            emailInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            confirmEmailTextField.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 20),
            confirmEmailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmEmailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmEmailTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
        ])
    }
    
    private func setupBinds() {
        emailInputView.didChangeText = { [weak self] text in
            self?.tableView.filterDomains(for: text)
        }
        
        emailInputView.didBeginEditing = { [weak self] in
            self?.tableView.showTableView()
        }
        
        emailInputView.didEndEditing = { [weak self] in
            self?.tableView.hideTableView()
        }
        
        tableView.didSelectItem = { [weak self] selectedItem in
            self?.emailInputView.suggestionSelected(selectedItem)
        }
    }
}
