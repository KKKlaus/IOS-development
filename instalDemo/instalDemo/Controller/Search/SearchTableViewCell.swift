//
//  SearchTableViewCell.swift
//  instalDemo
//
//  Created by Zihao Lin on 4/11/19.
//  Copyright © 2019 Zihao Lin. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchName: UILabel!
    @IBOutlet weak var searchEmail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //turn the picture into circle
        searchImage.layer.cornerRadius = searchImage.frame.size.width / 2
        searchImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
