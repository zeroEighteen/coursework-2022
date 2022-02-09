//
//  MyStallAddViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 19/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

struct MyStallAddField {
    var name: String
    var placeholder: String
    var type: InputType = .default
    var value = ""
}

class MyStallAddViewController: ModalActionViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tableView = UITableView(frame: CGRect(), style: .insetGrouped)
    
    var myStallViewController: MyStallViewController!
    
    let myStallAddCellIdentifier = "myStallAddCell"
    
    var fields = [
        MyStallAddField(name: "Name", placeholder: "Chicken Rice"),
        MyStallAddField(name: "Description", placeholder: "Delicious Food!"),
        MyStallAddField(name: "Price", placeholder: "1.50", type: .decimalPad),
    ]
    
    @objc func addNewFoodItem() {
        Stall.addStalls(foodItem: FoodItemDetails(name: fields[0].value, desc: fields[1].value, price: Double(fields[2].value) ?? 0, stallName: myStallViewController.stallName), to: appDelegate.admin.stallOwner!.stallName, completionHandler: {
            self.myStallViewController.refreshStallsData()
            self.dismiss(animated: true)
        })
    }
    
    private func setupUi() {
        let headerLabel = UILabel()
        contentView.addSubview(headerLabel)
        headerLabel.text = "Add New Food Item"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
        ])
        
        self.contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: K.margin)
        ])
    }
    
    @objc func onTapOutsideField() {
        view.endEditing(true)
    }
    // MARK: ModalActionTableViewController
    
    init() {
        super.init(actions: [ModalActionAction(title: "Add Food Item", action: #selector(addNewFoodItem), isPrimary: true)], target: nil)
        self.target = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(InputTableViewCell.self, forCellReuseIdentifier: myStallAddCellIdentifier)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapOutsideField))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
        setupUi()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myStallAddCellIdentifier, for: indexPath) as! InputTableViewCell
        let field = fields[indexPath.row]
        cell.textLabel?.text = field.name
        cell.placeholder = field.placeholder
        cell.type = field.type
        cell.onChange = { (value) -> Void in
            self.fields[indexPath.row].value = value
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.buttonHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === tableView
    }
}
