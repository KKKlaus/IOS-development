//
//  ProductModel.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation

class ProductModel{
    var prodcutID: String!
    
    var name: String!
    var ownerUID: String!
    var description: String!
    var imageURL: String!
    var price: String!
    
    init(prodcutID: String!, dictionary: Dictionary<String, AnyObject>) {
        self.prodcutID = prodcutID
        
        if let name = dictionary["name"] as? String{
            self.name = name
        }
        if let ownerUID = dictionary["ownerUID"] as? String{
            self.ownerUID = ownerUID
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
        if let prodcutID = dictionary["prodcutID"] as? String{
            self.prodcutID = prodcutID
        }
    }
}
