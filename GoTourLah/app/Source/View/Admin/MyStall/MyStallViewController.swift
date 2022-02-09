//
//  AdminListingViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 14/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class MyStallViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var stallName: StallName!
    var data: [FoodItem] = []
    
    @objc func addNewFoodItem() {
        let myStallAddViewController = MyStallAddViewController()
        myStallAddViewController.myStallViewController = self
        self.present(myStallAddViewController, animated: true)
    }
    
    func refreshStallsData() {
        Stall.getStalls { (stalls) in
            self.data = stalls.filter({$0.name == self.appDelegate.admin.stallOwner!.stallName})[safe: 0]?.foodItems ?? []
            self.tableView.reloadData()
        }
    }
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFoodItem))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myStallFoodItemCell")
        
        refreshStallsData()
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
