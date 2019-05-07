//
//  UserModel.swift
//  shoppingApp
//
//  Created by Zihao Lin on 4/22/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation

class UserModel{
    var userId: String!
    
    var name: String!
    var location: String!
    var imageURL: String!
    var email: String!
    var signupDate: Date!
    
    init(userId: String!, dictionary: Dictionary<String, AnyObject>) {
        self.userId = userId
        
        if let location = dictionary["location"] as? String{
            self.location = location
        }
        if let email = dictionary["email"] as? String{
            self.email = email
        }
        if let name = dictionary["name"] as? String{
            self.name = name
        }
        if let imageURL = dictionary["imageURL"] as? String{
            self.imageURL = imageURL
        }
        if let signupDate = dictionary["signupDate"] as? Double{
            self.signupDate = Date(timeIntervalSince1970: signupDate)
        }
        
    }
}
