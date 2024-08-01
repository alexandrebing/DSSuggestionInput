//
//  DSSuggestionListTableView.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit


class DSSuggestionListTableView: UITableView {
    
    var dataList: [String]
    var filteredDomains: [String] = []
    var didSelectItem: ((String) -> Void)?
    var namePart: String = ""
    
    init(dataList: [String], frame: CGRect = .zero, style: UITableView.Style = .plain) {
        self.dataList = dataList
        super.init(frame: frame, style: style)
        self.setupTableView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setupTableView() {
        
        self.delegate = self
        self.dataSource = self
        
        self.isScrollEnabled = false
        self.backgroundColor = .clear
        self.isHidden = true
        self.layer.cornerRadius = 5.0
        
        self.register(UITableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
    
    public func filterDomains(for text: String) {
        guard let range = text.range(of: "@") else {
            filteredDomains = []
            self.isHidden = true
            return
        }
        
        let domainPart = String(text[range.upperBound...])
        self.namePart = String(text[...range.lowerBound])
        filteredDomains = dataList.filter { $0.hasPrefix(domainPart) }
        
        self.reloadData()
        self.isHidden = filteredDomains.isEmpty
        updateTableViewHeight()
    }
    
    public func showTableView() {
        self.isHidden = filteredDomains.isEmpty
        updateTableViewHeight()
    }
    
    public func hideTableView() {
        self.isHidden = true
    }
    
    private func updateTableViewHeight() {
        let rowHeight: CGFloat = 44.0
        let totalHeight = rowHeight * CGFloat(filteredDomains.count)
        
        self.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                self.removeConstraint(constraint)
            }
        }
        
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}

extension DSSuggestionListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDomains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        cell.textLabel?.text = "\(namePart)\(filteredDomains[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = "\(namePart)\(filteredDomains[indexPath.row])"
        
        self.filterDomains(for: selectedItem)
        self.didSelectItem?(selectedItem)
        hideTableView()
    }
}
