//
//  PostModel.swift
//  instalDemo
//
//  Created by Zihao Lin on 4/2/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import Foundation

class PostModel{
    
    var title : String!
    var likes : Int!
    var imageURL: String!
    var ownerUID : String!
    var creationDate : Date!
    var postId : String!
    
    init(postId: String!, dictionary: Dictionary<String, AnyObject>) {
        self.postId = postId
        
        if let title = dictionary["title"] as? String{
            self.title = title
        }
        if let ownerUID = dictionary["ownerUID"] as? String{
            self.ownerUID = ownerUID
        }
        if let likes = dictionary["likes"] as? Int{
            self.likes = likes
        }
        if let imageURL = dictionary["imageURL"] as? String{
            self.imageURL = imageURL
        }
        if let creationDate = dictionary["creationDate"] as? Double{
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
}
