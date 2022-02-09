//
//  StallsViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 12/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit
import GoogleSignIn

class StallsViewController: UICollectionViewController, UISearchBarDelegate {
    
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    var searchString = ""
    var searchController = UISearchController()
    
    var stall: Stall?

    var data: [Stall] = []
    var filterStallData: [Stall] {
        data.filter { searchString == "" ? true : $0.name.lowercased().contains(searchString) }
    }
    var filterFoodItemData: [FoodItem] {
        return stall?.foodItems.filter { searchString == "" ? true : $0.name.lowercased().contains(searchString) } ?? []
    }
    
    func refreshStallsData() {
        Stall.getStalls(completionHandler: { (data) -> Void in
            self.data = data
            self.collectionView.reloadData()
        })
    }
    
    @objc func presentCartViewController() {
        let cartViewController = CartViewController()
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)
        self.navigationController?.present(cartNavigationController, animated: true, completion: nil)
    }
    
    func presentFoodItemsViewController(for stall: Stall) {
        let foodItemsViewController = StallsViewController(for: stall)
        self.navigationController?.pushViewController(foodItemsViewController, animated: true)
    }
    
    // MARK: UICollectionViewController
    
    init(for stall: Stall? = nil) {
        func createGridLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute((UIScreen.main.bounds.width-K.margin*3)/2), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = NSCollectionLayoutSpacing.fixed(K.margin)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = K.margin
                
                section.contentInsets = NSDirectionalEdgeInsets(top: K.margin, leading: K.margin, bottom: K.margin, trailing: K.margin)
                return section
            }
            return layout
        }
        self.stall = stall
        super.init(collectionViewLayout: createGridLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stall?.name ?? "Eat"
        self.collectionView.backgroundColor = .systemGroupedBackground
        
        self.navigationItem.searchController = searchController
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(presentCartViewController))
        self.view.addSubview(collectionView)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.collectionView.register(StallsCollectionViewCell.self, forCellWithReuseIdentifier: "stallsCollectionViewCell")
        
        refreshStallsData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stall == nil ? filterStallData.count : filterFoodItemData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stallsCollectionViewCell", for: indexPath) as! StallsCollectionViewCell
        cell.titleLabel.text = stall == nil ? filterStallData[indexPath.row].name : filterFoodItemData[indexPath.row].name
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let stall = stall {
            let addToCartViewController = AddToCartViewController(stall: stall, foodItem: stall.foodItems[indexPath.row])
            let navigationController = UINavigationController(rootViewController: addToCartViewController)
            addToCartViewController.presentingStallsViewController = self
            self.navigationController?.present(navigationController, animated: true)
        } else {
            self.presentFoodItemsViewController(for: filterStallData[indexPath.row])
        }
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText.lowercased()
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchString = ""
        self.collectionView.reloadData()
    }
    
}
