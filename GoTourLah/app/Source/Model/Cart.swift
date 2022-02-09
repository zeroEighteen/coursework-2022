//
//  Cart.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 23/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit
import CoreData

class Cart {
        
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Barg-InnoFest")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("ERROR: %@ \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("ERROR: %@ \(error)")
            }
        }
    }
        
    func loadCart() -> [FoodItemEntity] {
        let context = persistentContainer.viewContext
        var foodItems: [FoodItemEntity]
        do {
            foodItems = try context.fetch(FoodItemEntity.fetchRequest())
        } catch let error as NSError {
            fatalError("ERROR: %@ \(error)")
        }
        return foodItems
    }
        
    func addToCart(with foodItemDetails: FoodItemDetails) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FoodItemEntity", in: context)!
        let foodItem = FoodItemEntity(entity: entity, insertInto: context)
        
        foodItem.name = foodItemDetails.name
        foodItem.desc = foodItemDetails.desc
        foodItem.price = foodItemDetails.price
        foodItem.stallName = foodItemDetails.stallName
        
        saveContext()
    }
    
    func removeFromCart(_ foodItem: FoodItemEntity) {
        let context = persistentContainer.viewContext
        context.delete(foodItem)
        
        saveContext()
    }
    
    func clearCart() {
        let context = persistentContainer.viewContext
        let deleteReq = NSBatchDeleteRequest(fetchRequest: FoodItemEntity.fetchRequest())
        do {
            try context.execute(deleteReq)
        } catch let error as NSError {
            fatalError("ERROR: %@ \(error)")
        }
    }

}
