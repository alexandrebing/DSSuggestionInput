//
//  ViewController2.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        tableView.isHidden = true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 5.0
        return tableView
    }()
    
    private let domains = ["gmail.com", "yahoo.com", "outlook.com", "icloud.com"]
    private var filteredDomains: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            emailInputView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "domainCell")
        
        emailInputView.didChangeText = { [weak self] text in
            self?.filterDomains(for: text)
        }
        
        emailInputView.didBeginEditing = { [weak self] in
            self?.showTableView()
        }
        
        emailInputView.didEndEditing = { [weak self] in
            self?.hideTableView()
        }
    }
    
    private func filterDomains(for text: String) {
        guard let range = text.range(of: "@") else {
            filteredDomains = []
            tableView.isHidden = true
            return
        }
        
        let domainPart = String(text[range.upperBound...])
        filteredDomains = domains.filter { $0.hasPrefix(domainPart) }
        
        tableView.reloadData()
        tableView.isHidden = filteredDomains.isEmpty
        updateTableViewHeight()
    }
    
    private func showTableView() {
        tableView.isHidden = filteredDomains.isEmpty
        updateTableViewHeight()
    }
    
    private func hideTableView() {
        tableView.isHidden = true
    }
    
    private func updateTableViewHeight() {
        let rowHeight: CGFloat = 44.0
        let totalHeight = rowHeight * CGFloat(filteredDomains.count)
        
        tableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                tableView.removeConstraint(constraint)
            }
        }
        
        tableView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDomains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "domainCell", for: indexPath)
        cell.textLabel?.text = filteredDomains[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDomain = filteredDomains[indexPath.row]
        if let text = emailInputView.text, let range = text.range(of: "@") {
            emailInputView.text = String(text[..<range.upperBound]) + selectedDomain
        } else {
            emailInputView.text = selectedDomain
        }
        
        hideTableView()
        emailInputView.resignFirstResponder()
    }
}


//class ViewController2: UIViewController {
//    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        return scrollView
//    }()
//    
//    private let contentView: UIView = {
//        let view = UIView()
//        return view
//    }()
//    
//    private lazy var sugestionInput: DSTextInput = {
//        return DSTextInput(placeholder: "Type your email")
//    }()
//    
//    private lazy var tableView: DSSuggestionListTableView = {
//        let tableView = DSSuggestionListTableView(dataList: domains)
//        tableView.isHidden = true
//        tableView.layer.borderColor = UIColor.lightGray.cgColor
//        tableView.layer.borderWidth = 1.0
//        tableView.layer.cornerRadius = 5.0
//        return tableView
//    }()
//    
//    private let confirmEmailTextField: UITextField = {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.placeholder = "Confirm your email"
//        return textField
//    }()
//    
//    private let domains = ["gmail.com", "yahoo.com", "outlook.com", "icloud.com", "yahoo.com.br", "hotmail.com", "msn.com"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupView()
//        self.setupBinds()
//    }
//    
//    private func setupView() {
//        view.backgroundColor = .systemBlue
//        
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(sugestionInput)
//        contentView.addSubview(confirmEmailTextField)
//        view.addSubview(tableView)
//        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        sugestionInput.translatesAutoresizingMaskIntoConstraints = false
//        confirmEmailTextField.translatesAutoresizingMaskIntoConstraints = false
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            
//            sugestionInput.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            sugestionInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            sugestionInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            confirmEmailTextField.topAnchor.constraint(equalTo: sugestionInput.bottomAnchor, constant: 20),
//            confirmEmailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            confirmEmailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            confirmEmailTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//            
//            tableView.topAnchor.constraint(equalTo: sugestionInput.bottomAnchor, constant: 5),
//            tableView.leadingAnchor.constraint(equalTo: sugestionInput.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: sugestionInput.trailingAnchor)
//            
//        ])
//    }
//    
//    private func setupBinds() {
//        sugestionInput.didChangeText = { [weak self] text in
//            self?.tableView.filterDomains(for: text)
//        }
//        
//        sugestionInput.didBeginEditing = { [weak self] in
//            self?.tableView.showTableView()
//        }
//        
//        sugestionInput.didEndEditing = { [weak self] in
//            self?.tableView.hideTableView()
//        }
//    }
//}
//
