//
//  HomeTableViewCell.swift
//  instalDemo
//
//  Created by Zihao Lin on 4/11/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit


class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //turn the picture into circle
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
