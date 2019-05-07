//
//  UserModel.swift
//  instalDemo
//
//  Created by Zihao Lin on 4/2/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation

class UserModel{
    var name: String!
    var title: String!
    var imageURL: String!
    var email: String!
    var userId: String!
    var signupDate: Date!
    
    init(userId: String!, dictionary: Dictionary<String, AnyObject>) {
        self.userId = userId
        
        if let title = dictionary["title"] as? String{
            self.title = title
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
