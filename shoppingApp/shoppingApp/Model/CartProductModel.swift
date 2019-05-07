//
//  CartProduct.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/23/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation

class CartProductModel{
    var prodcutID: String!
    
    var name: String!
    var count: String!
    var description: String!
    var imageURL: String!
    var price: String!
    
    init(prodcutID: String!, dictionary: Dictionary<String, AnyObject>) {
        self.prodcutID = prodcutID
        
        if let name = dictionary["name"] as? String{
            self.name = name
        }
        if let count = dictionary["count"] as? String{
            self.count = count
        }
        if let description = dictionary["description"] as? String{
            self.description = description
        }
        if let imageURL = dictionary["imageURL"] as? String{
            self.imageURL = imageURL
        }
        if let price = dictionary["price"] as? String{
            self.price = price
        }
    }
}
