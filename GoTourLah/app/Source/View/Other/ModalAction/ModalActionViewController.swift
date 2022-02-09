//
//  ModalActionViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 1/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

struct ModalActionAction {
    var title: String
    var action: Selector
    var image: UIImage?
    var isPrimary: Bool? = false
}

class ModalActionViewController: UIViewController {

    var contentView: UIView!
    var actions: [ModalActionAction]!
    var target: Any?
    
    private func setupUi() {
        let actionButtons = actions?.map { (introAction) -> UIButton in
            let button = UIButton(type: .roundedRect)
            button.backgroundColor = introAction.isPrimary! ? .accent : .none
            button.tintColor = introAction.isPrimary! ? .white : .accent
            button.setTitle(introAction.title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: button.titleLabel!.font.pointSize, weight: introAction.isPrimary! ? .medium : .regular)
            button.addTarget(target, action: introAction.action, for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: K.buttonHeight).isActive = true
            button.layer.cornerRadius = K.cornerRadius
            if let image = introAction.image {
                button.setImage(image, for: .normal)
                button.imageEdgeInsets.right += 10
                button.titleEdgeInsets.left = 10
            }
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: actionButtons!)
        self.view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: K.margin),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -K.margin),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -K.margin),
        ])
        
        if let contentView = contentView {
            self.view.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints([
                contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -K.margin),
                contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
            ])
        }
        
        let view = UIView()
        view.backgroundColor = .blue
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
//            view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//            view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            view.heightAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    // MARK: UIViewController
    
    init(contentView: UIView? = UIView(), actions: [ModalActionAction], target: Any?) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        self.contentView = contentView
        self.actions = actions
        self.target = target
        
        setupUi()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
