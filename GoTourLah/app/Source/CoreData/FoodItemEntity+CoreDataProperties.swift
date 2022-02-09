//
//  FoodItemEntity+CoreDataProperties.swift
//  
//
//  Created by Ryan The on 20/9/20.
//
//

import Foundation
import CoreData


extension FoodItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItemEntity> {
        return NSFetchRequest<FoodItemEntity>(entityName: "FoodItemEntity")
    }

    @NSManaged public var desc: String
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var stallName: String

}
