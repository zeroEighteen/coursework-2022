//
//  OrdersViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 20/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class OrdersViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var stallName: StallName!
    var data: [FoodItem] = []
    
    // MARK: UITableViewController
    
    init(for stallName: StallName) {
        super.init(nibName: nil, bundle: nil)
        self.stallName = stallName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myStallFoodItemCell")
                
        Stall.getOrders(for: stallName) { (foodItems) in
            self.data = foodItems
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myStallFoodItemCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            let confirmAlert = UIAlertController(title: "Confirm Delete", message: "You cannot undo this change.", preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                completionHandler(false)
            }))
            confirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                Stall.deleteStalls(foodItem: self.data[indexPath.row], from: self.stallName) {
                    
                }
                self.data.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }))
            self.present(confirmAlert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
