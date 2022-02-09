//
//  WhatsNewViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 1/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

struct IntroAction {
    var title: String
    var action: Selector
    var isPrimary: Bool? = false
}

class ModalActionViewController: UIViewController {

    init(title: String, actions: [IntroAction], contentView: UIView? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        self.isModalInPresentation = true
        
        let headerLabel = UILabel()
        self.view.addSubview(headerLabel)
        headerLabel.text = title
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            headerLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
        ])
        
        let actionButtons = actions.map { (introAction) -> UIButton in
            let button = UIButton(type: .roundedRect)
            button.backgroundColor = introAction.isPrimary! ? .link : .none
            button.titleLabel?.text = introAction.title
            button.addTarget(self, action: introAction.action, for: .touchUpInside)
            return button
        }
        let stackView = UIStackView(arrangedSubviews: actionButtons)
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            stackView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
