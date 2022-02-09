//
//  InputTableViewCell.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 19/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

typealias InputType = UIKeyboardType

class InputTableViewCell: UITableViewCell {

    lazy private var inputField: UITextField = {
        let inputField = UITextField()
        inputField.textAlignment = .right
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.addTarget(self, action: #selector(inputFieldDidChange), for: .editingChanged)
        return inputField
    }()
    
    @objc func inputFieldDidChange(sender: UITextField!) {
        onChange(sender.text ?? "")
    }
    
    public var type: InputType = .default
    
    public var onChange: (String) -> Void = {_ in }
    
    public var placeholder: String {
        get {
            return inputField.placeholder ?? ""
        }
        set(value) {
            inputField.placeholder = value
        }
    }
    
    // MARK: UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(inputField)
        self.addConstraints([
            inputField.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            inputField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        inputField.keyboardType = self.type
        inputField.becomeFirstResponder()
    }
    
}
