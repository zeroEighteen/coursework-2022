//
//  ViewController.swift
//  CrudApp
//
//  Created by Ryan The on 1/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit
import SnapKit

class StallsVC: UIViewController {
	
	var tableView: MainTableView {
		let tableView = MainTableView(frame: CGRect(), style: .plain)
		tableView.parent = self
		return tableView
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.title = "Stalls"
		self.view.backgroundColor = .systemBackground
		self.view.addSubview(tableView)
		
	}
	
	func presentView() {
		let newVC = UIViewController()
		self.navigationController?.pushViewController(newVC, animated: true)
	}
}

