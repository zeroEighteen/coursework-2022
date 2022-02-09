//
//  CartTableView.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 15/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class CartTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate

    var viewController: CartViewController!
    
    var data: [FoodItemEntity] {
        get {
            viewController.data
        }
        set(newData) {
            viewController.data = newData
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(CartTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row].name
        cell.imageView?.image = K.foodPlaceholderImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewController.presentCartItemViewController()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_,_,_) in
            self.appDelegate.cart.removeFromCart(self.data[indexPath.row])
            self.data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let star = UIContextualAction(style: .normal, title: Stall.isFoodItemStar(for: data[indexPath.row]) ? "Unstar" : "Star") { (_, _, completionHandler) in
            Stall.toggleFoodItemStar(for: self.data[indexPath.row])
            completionHandler(true)
        }
        star.image = UIImage(systemName: Stall.isFoodItemStar(for: data[indexPath.row]) ? "star.slash.fill" : "star.fill")
        star.backgroundColor = .accent
        
        return UISwipeActionsConfiguration(actions: [star])
    }
    
}
