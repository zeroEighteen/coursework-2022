//
//  Stalls.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 15/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum StallModelType: String {
    case select = "select", set = "set"
}

struct StallOwner {
    var uid: String
    var stallName: StallName
}

typealias StallName = String

protocol FoodItem {
    var name: String { get set }
    var desc: String { get set }
    var price: Double { get set }
    var stallName: String { get set }
    var toDictionary: [String: Any] { get }
    static func fromDictionary(_: [String: Any]) -> FoodItem
}

struct FoodItemDetails: FoodItem {
    var name: String
    var desc: String
    var price: Double
    var stallName: String
    var toDictionary: [String: Any] {
        return [
            "name": self.name,
            "desc": self.desc,
            "price": self.price,
            "stallName": self.stallName,
        ]
    }
    static func fromDictionary(_ dictionary: [String: Any]) -> FoodItem {
        let name = dictionary["name"] as! String
        let desc = dictionary["desc"] as! String
        let price = dictionary["price"] as! Double
        let stallName = dictionary["stallName"] as! String
        return FoodItemDetails(name: name, desc: desc, price: price, stallName: stallName)
    }
}

class Stall {
    var name: String
    var desc: String
    var model: StallModelType
    var foodItems: [FoodItem]
    var toDictionary: [String: Any] {
        let foodItems = self.foodItems.map { (foodItem) -> [String: Any] in
            return foodItem.toDictionary
        }
        return [
            "name": self.name,
            "desc": self.desc,
            "model": self.model,
            "foodItems": foodItems,
        ]
    }
    static func fromDictionary(_ dictionary: [String: Any]) -> Stall {
        let foodItems = (dictionary["foodItems"] as! [[String: Any]]).map { FoodItemDetails.fromDictionary($0) }
        
        return Stall(name: dictionary["name"] as! String, desc: dictionary["desc"] as! String, model: StallModelType(rawValue: dictionary["model"] as! String) ?? .select, foodItems: foodItems)
    }
    
    init(name: String, desc: String, model: StallModelType, foodItems: [FoodItem]) {
        self.name = name
        self.desc = desc
        self.model = model
        self.foodItems = foodItems
    }
    
    static func getStalls(completionHandler: @escaping ([Stall]) -> Void) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        appDelegate.firestoreDb?.collection("stalls").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                fatalError("ERROR: %@ \(error)")
            }
            if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                let stalls = querySnapshot.documents.map { (document) -> Stall in
                    return Stall.fromDictionary(document.data())
                }
                completionHandler(stalls)
            }
        })
    }
    
    static func deleteStalls(foodItem: FoodItem, from stallName: StallName, completionHandler: @escaping () -> Void) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        appDelegate.firestoreDb?.collection("stalls").document(stallName).updateData(["foodItems": FieldValue.arrayRemove([foodItem.toDictionary])]) { error in
            if let error = error {
                fatalError("ERROR: \(error)")
            }
        }
    }
    
    static func addStalls(foodItem: FoodItem, to stallName: StallName, completionHandler: @escaping () -> Void) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        appDelegate.firestoreDb?.collection("stalls").document(stallName).updateData(["foodItems": FieldValue.arrayUnion([foodItem.toDictionary])]) { error in
            if let error = error {
                fatalError("ERROR: \(error)")
            }
            completionHandler()
        }
    }
    
    static func getOrders(for stallName: StallName, completionHandler: @escaping ([FoodItem]) -> Void) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        appDelegate.firestoreDb?.collection("stalls").document(stallName).collection("orders").addSnapshotListener({ (querySnapshot, error) in
            if let error = error {
                fatalError("ERROR: %@ \(error)")
            }
            if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                let foodItems = querySnapshot.documents.map { (document) -> FoodItem in
                    print(document.data())
                    return FoodItemDetails.fromDictionary(document.data())
                }
                completionHandler(foodItems)
            }
        })
    }
    
    static func sendTransactionRequest(foodItem: FoodItem, for stallName: StallName, completionHandler: @escaping () -> Void) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        appDelegate.firestoreDb?.collection("stalls").document(stallName).collection("orders").addDocument(data: foodItem.toDictionary) { error in
            if let error = error {
                fatalError("ERROR: \(error)")
            }
            completionHandler()
        }
    }
    
    static func toggleFoodItemStar(for foodItem: FoodItem) {
        if (UserDefaults.standard.array(forKey: "favorites") == nil) {
            UserDefaults.standard.set([], forKey: "favorites")
        }
        let favorites = UserDefaults.standard.array(forKey: "favorites")! as! [String]
        var newFavorites = favorites
        if favorites.contains(where: { $0 == foodItem.name }) {
            newFavorites.removeAll { $0 == foodItem.name }
        } else {
            newFavorites.append(foodItem.name)
        }
        UserDefaults.standard.set(newFavorites, forKey: "favorites")
    }
    
    static func isFoodItemStar(for foodItem: FoodItem) -> Bool {
        if (UserDefaults.standard.array(forKey: "favorites") == nil) {
            UserDefaults.standard.set([], forKey: "favorites")
        }
        let favorites = UserDefaults.standard.array(forKey: "favorites")! as! [String]
        return favorites.contains { $0 == foodItem.name }
    }
    
    
}
