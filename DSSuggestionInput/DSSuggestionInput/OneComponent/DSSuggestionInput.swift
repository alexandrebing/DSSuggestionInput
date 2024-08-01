//
//  DSSuggestionInput.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit

class DSSuggestionInput: UITextField {
    
    var dataList: [String]
    var filteredDataList: [String] = []
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.isHidden = true
        
        return tableView
    }()
    
    var didBeginEditing: (() -> Void)?
    var didChangeText: ((String) -> Void)?
    var didEndEditing: (() -> Void)?
    var didSelectDomain: ((String) -> Void)?
    
    init(placeholder: String, dataList: [String]) {
        self.dataList = dataList
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.7
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.layer.shadowRadius = 10
        self.clipsToBounds = false
        self.delegate = self
        self.setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView.removeFromSuperview()

    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.delegate = self
        self.addTarget(self, action: #selector(DSSuggestionInput.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(DSSuggestionInput.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(DSSuggestionInput.textFieldDidEndEditing), for: .editingDidEnd)
        //        self.addTarget(self, action: #selector(SuggestionTextInput.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSuggestionTableView()
    }
    
    private func setupBinding() {
        
        buildSuggestionTableView()
        
        tableView.clipsToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.8
        tableView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableView.layer.shadowRadius = 5
        
        didChangeText = { [weak self] text in
            self?.filterDomains(for: text)
        }
        
        didBeginEditing = { [weak self] in
            // self?.showTableView()
        }
        
        didEndEditing = { [weak self] in
            self?.hideTableView()
        }
        
        didSelectDomain = { [weak self] domain in
            guard let inputText = self?.text else { return }
            if let range = inputText.range(of: "@") {
                self?.text = String(inputText[..<range.upperBound]) + domain
            } else {
                self?.text = inputText + domain
            }
            self?.filterDomains(for: inputText + domain)
            self?.hideTableView()
            self?.resignFirstResponder()
        }
    }
    
    private func filterDomains(for text: String) {
        guard let range = text.range(of: "@") else {
            tableView.isHidden = true
            return
        }
        
        let domainPart = String(text[range.upperBound...])
        let filteredDomains = dataList.filter { $0.hasPrefix(domainPart) }
        
        filteredDataList = filteredDomains
        
        self.updateSearchTableView()
        tableView.isHidden = filteredDomains.isEmpty
    }
    
    private func showTableView() {
        tableView.isHidden = false
    }
    
    private func hideTableView() {
        tableView.isHidden = true
    }
    
}

extension DSSuggestionInput: UITextFieldDelegate {
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        didChangeText?(textField.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?()
    }
}

extension DSSuggestionInput: UITableViewDelegate, UITableViewDataSource {
    
    func buildSuggestionTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.window?.addSubview(tableView)
        
        
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        
        
        superview?.bringSubviewToFront(tableView)
        var tableHeight: CGFloat = 0
        tableHeight = tableView.contentSize.height
        
        // Set a bottom margin of 10p
        if tableHeight < tableView.contentSize.height {
            tableHeight -= 10
        }
        
        // Set tableView frame
        var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: tableHeight)
        tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
        //tableViewFrame.origin.x += 2
        tableViewFrame.origin.y += frame.size.height + 1
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.tableView.frame = tableViewFrame
        })
        
        //Setting tableView style
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layer.cornerRadius = 5.0
        tableView.separatorColor = UIColor.lightGray
        //tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        if self.isFirstResponder {
            superview?.bringSubviewToFront(self)
        }
        
        tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredDataList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectDomain?(filteredDataList[indexPath.row])
    }
    
    
}
