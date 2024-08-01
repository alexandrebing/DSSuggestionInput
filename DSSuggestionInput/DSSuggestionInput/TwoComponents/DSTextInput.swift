//
//  DSTextInput.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit

class DSTextInput: UITextField, UITextFieldDelegate {
    
    var didBeginEditing: (() -> Void)?
    var didChangeText: ((String) -> Void)?
    var didEndEditing: (() -> Void)?
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        didChangeText?(textField.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?()
    }
    
    func suggestionSelected(_ text: String) {
        self.text = text
        self.resignFirstResponder()
    }
}
