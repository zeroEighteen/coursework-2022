//
//  WhatsNewViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 1/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = .systemBackground
        self.isModalInPresentation = true
        
        let headerLabel = UILabel()
        self.view.addSubview(headerLabel)
        headerLabel.text = "What's New In Barg"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
