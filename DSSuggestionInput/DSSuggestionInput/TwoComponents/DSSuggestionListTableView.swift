//
//  DSSuggestionListTableView.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit


class DSSuggestionListTableView: UITableView {
    
    var dataList: [String]
    var filteredDataList: [String] = []
    var didSelectItem: ((String) -> Void)?
    
    init(dataList: [String], frame: CGRect = .zero, style: UITableView.Style = .plain) {
        self.dataList = dataList
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setupTableView() {
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        // Adiciona sombra na base da UITableView
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    // Método para filtrar domínios com base no texto
    func filterDomains(for text: String) {
        guard let range = text.range(of: "@") else {
            filteredDataList = []
            return
        }
        
        let domainPart = String(text[range.upperBound...])
        filteredDataList = dataList.filter { $0.hasPrefix(domainPart) }
        self.updateTableViewHeight()
        self.reloadData()
    }
    
    func showTableView() {
        self.isHidden = filteredDataList.isEmpty
        updateTableViewHeight()
    }
    
    func hideTableView() {
        self.isHidden = true
    }
    
    private func updateTableViewHeight() {
        let rowHeight: CGFloat = 44.0
        let totalHeight = rowHeight * CGFloat(filteredDataList.count)
        
        self.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                self.removeConstraint(constraint)
            }
        }
        
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        
        DispatchQueue.main.async {
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
    }
}

extension DSSuggestionListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        cell.textLabel?.text = filteredDataList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectItem?(filteredDataList[indexPath.row])
    }
}
