//
//  CartViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 15/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class CartViewController: ModalActionViewController {
    
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate

    var tableView = CartTableView(frame: CGRect(), style: .insetGrouped)
		
    var data: [FoodItemEntity] = (UIApplication.shared.delegate as! AppDelegate).cart.loadCart()
    
    init() {
        super.init(actions: [
            ModalActionAction(title: "Proceed to Checkout", action: #selector(proceedToPayment), image: UIImage(systemName: "dollarsign.circle"), isPrimary: true),
        ], target: nil)
        self.target = self
        self.title = "Cart"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCartViewController))
        setupUi()
    }
    
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
    private func setupUi() {
        self.contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        tableView.viewController = self
    }
	
	func presentCartItemViewController() {
		let cartItemViewController = UIViewController()
		cartItemViewController.view.backgroundColor = .systemBackground
		self.navigationController?.pushViewController(cartItemViewController, animated: true)
	}
	
	@objc func dismissCartViewController() {
		self.dismiss(animated: true)
	}
    
    @objc func proceedToPayment() {
        let alert = UIAlertController(title: "Proceed to Payment", message: "You will be directed to your payment application.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
        }))
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let successAlert = UIAlertController(title: "Payment Success", message: "Your payment was successfully received. You may proceed to collect your meal now. ", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.data.forEach { (foodItem) in
                    Stall.sendTransactionRequest(foodItem: foodItem, for: foodItem.stallName) {
                        
                    }
                }
//                Stall.sendTransactionRequest() { (didSuccess) in
//                    if didSuccess {
//                        self.appDelegate.cart.clearCart()
//                        self.dismiss(animated: true)
//                    } else {
//                        let failAlert = UIAlertController(title: "Transaction Failed", message: "Say bye to your money!", preferredStyle: .alert)
//                        failAlert.addAction(UIAlertAction(title: "Cry", style: .destructive))
//                        self.present(failAlert, animated: true)
//                    }
//                }
            }))
            self.present(successAlert, animated: true)
        }
    }
}
